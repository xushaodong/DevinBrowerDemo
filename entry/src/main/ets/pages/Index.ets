/**
 * Nova Browser - Main Index Page
 * The primary browser interface containing:
 *   - Address bar (in browser mode)
 *   - Home page view (default landing)
 *   - Web content view (when navigating)
 *   - Bottom toolbar (always visible)
 *   - Menu panel overlay
 */

import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import { TabInfo, HistoryItem, QuickSite } from '../model/BrowserModels';
import { BrowserDataManager } from '../common/BrowserDataManager';
import { AppColors, AppDimens, UrlUtils } from '../common/Constants';
import { HomePage } from '../components/HomePage';
import { BrowserToolbar } from '../components/BrowserToolbar';
import { MenuPanel } from '../components/MenuPanel';

@Entry
@Component
struct Index {
  /** Current view mode: 'home' or 'browser' */
  @State currentView: string = 'home';
  /** Text in the address/search bar */
  @State searchText: string = '';
  /** Whether a page is currently loading */
  @State isLoading: boolean = false;
  /** Loading progress (0-100) */
  @State loadProgress: number = 0;
  /** Whether the WebView can go back */
  @State canGoBack: boolean = false;
  /** Whether the WebView can go forward */
  @State canGoForward: boolean = false;
  /** Whether the menu panel is visible */
  @State showMenu: boolean = false;
  /** Current page title from WebView */
  @State pageTitle: string = '';
  /** Current page URL from WebView */
  @State pageUrl: string = '';
  /** Number of open tabs */
  @State tabCount: number = 1;
  /** Whether current tab is incognito */
  @State isIncognito: boolean = false;
  /** Quick sites for the home page */
  @State quickSites: QuickSite[] = [];
  /** Recent history items for home page display */
  @State recentHistory: HistoryItem[] = [];
  /** Whether to show delete site confirmation dialog */
  @State showDeleteSiteDialog: boolean = false;
  /** ID of site pending deletion */
  @State pendingDeleteSiteId: string = '';

  /** WebView controller instance */
  private webController: webview.WebviewController = new webview.WebviewController();
  /** Data manager singleton */
  private dataManager: BrowserDataManager = BrowserDataManager.getInstance();

  aboutToAppear(): void {
    this.syncFromDataManager();
  }

  onPageShow(): void {
    // Re-sync data when returning from other pages (e.g., TabListPage)
    this.syncFromDataManager();
    // If active tab has a URL, reload it in WebView
    const activeTab = this.dataManager.getActiveTab();
    if (activeTab !== null && activeTab.url.length > 0) {
      this.currentView = 'browser';
      this.pageUrl = activeTab.url;
      this.pageTitle = activeTab.title;
      this.searchText = activeTab.url;
    } else {
      this.currentView = 'home';
      this.searchText = '';
    }
  }

  /**
   * Sync component state from the data manager.
   */
  private syncFromDataManager(): void {
    this.tabCount = this.dataManager.getTabCount();
    this.quickSites = this.dataManager.quickSites;
    this.recentHistory = this.dataManager.getRecentHistory(10);
    const activeTab = this.dataManager.getActiveTab();
    if (activeTab !== null) {
      this.isIncognito = activeTab.isIncognito;
    }
  }

  /**
   * Handle search or URL navigation.
   */
  private handleSearch(input: string): void {
    if (input.trim().length === 0) {
      return;
    }

    let url: string;
    if (UrlUtils.isUrl(input)) {
      url = UrlUtils.normalizeUrl(input);
    } else {
      url = this.dataManager.getSearchUrl(input);
      // Record search history
      this.dataManager.addHistoryRecord(url, '搜索: ' + input, 'search');
    }

    this.navigateToUrl(url);
  }

  /**
   * Navigate the WebView to a specific URL.
   */
  private navigateToUrl(url: string): void {
    this.currentView = 'browser';
    this.pageUrl = url;
    this.searchText = url;
    this.isLoading = true;

    try {
      this.webController.loadUrl(url);
    } catch (e) {
      // WebView might not be initialized yet; URL will be loaded via src binding
    }
  }

  /**
   * Navigate to the tab list page.
   */
  private goToTabList(): void {
    // Save current tab state
    const activeTab = this.dataManager.getActiveTab();
    if (activeTab !== null && this.currentView === 'browser') {
      this.dataManager.updateActiveTab(this.pageUrl, this.pageTitle);
    }

    router.pushUrl({ url: 'pages/TabListPage' });
  }

  /**
   * Navigate to the history page.
   */
  private goToHistory(): void {
    this.showMenu = false;
    router.pushUrl({ url: 'pages/HistoryPage' });
  }

  /**
   * Navigate to the settings page.
   */
  private goToSettings(): void {
    this.showMenu = false;
    router.pushUrl({ url: 'pages/SettingsPage' });
  }

  /**
   * Create a new tab and go to home.
   */
  private createNewTab(isIncognito: boolean): void {
    this.showMenu = false;

    // Save current tab state
    const currentTab = this.dataManager.getActiveTab();
    if (currentTab !== null && this.currentView === 'browser') {
      this.dataManager.updateActiveTab(this.pageUrl, this.pageTitle);
    }

    this.dataManager.addNewTab(isIncognito);
    this.syncFromDataManager();
    this.currentView = 'home';
    this.searchText = '';
    this.pageUrl = '';
    this.pageTitle = '';
    this.canGoBack = false;
    this.canGoForward = false;
  }

  /**
   * Go back to the home view.
   */
  private goHome(): void {
    this.currentView = 'home';
    this.searchText = '';
    this.recentHistory = this.dataManager.getRecentHistory(10);
  }

  build() {
    Stack() {
      Column() {
        // Address bar (only in browser view)
        if (this.currentView === 'browser') {
          Column() {
            Row() {
              // SSL indicator
              if (this.pageUrl.startsWith('https://')) {
                Text('🔒')
                  .fontSize(AppDimens.FONT_SM)
                  .margin({ left: AppDimens.PADDING_MD, right: AppDimens.PADDING_XS })
              }

              // Address input
              TextInput({ text: this.searchText, placeholder: '搜索或输入网址' })
                .layoutWeight(1)
                .height(36)
                .backgroundColor(Color.Transparent)
                .fontSize(AppDimens.FONT_SM)
                .fontColor(this.isIncognito ? Color.White : AppColors.TEXT_PRIMARY)
                .placeholderColor(AppColors.TEXT_HINT)
                .caretColor(AppColors.PRIMARY)
                .maxLines(1)
                .enterKeyType(EnterKeyType.Go)
                .onChange((value: string) => {
                  this.searchText = value;
                })
                .onSubmit(() => {
                  this.handleSearch(this.searchText);
                })

              // Reload / Stop button
              if (this.isLoading) {
                Text('✕')
                  .fontSize(AppDimens.FONT_LG)
                  .fontColor(AppColors.TEXT_SECONDARY)
                  .padding({ right: AppDimens.PADDING_MD })
                  .onClick(() => {
                    try {
                      this.webController.stop();
                    } catch (e) {
                      // Ignore if WebView not ready
                    }
                    this.isLoading = false;
                  })
              } else {
                Text('↻')
                  .fontSize(AppDimens.FONT_XL)
                  .fontColor(AppColors.TEXT_SECONDARY)
                  .padding({ right: AppDimens.PADDING_MD })
                  .onClick(() => {
                    try {
                      this.webController.refresh();
                    } catch (e) {
                      // Ignore if WebView not ready
                    }
                  })
              }
            }
            .width('100%')
            .height(AppDimens.ADDRESS_BAR_HEIGHT)
            .borderRadius(AppDimens.BORDER_RADIUS_XL)
            .backgroundColor(this.isIncognito ? AppColors.INCOGNITO_SURFACE : AppColors.ADDRESS_BAR_BG)
            .margin({
              left: AppDimens.PADDING_MD,
              right: AppDimens.PADDING_MD,
              top: AppDimens.PADDING_SM,
              bottom: AppDimens.PADDING_SM
            })

            // Loading progress bar
            if (this.isLoading) {
              Progress({ value: this.loadProgress, total: 100, type: ProgressType.Linear })
                .width('100%')
                .height(2)
                .color(AppColors.PRIMARY)
            }
          }
          .backgroundColor(this.isIncognito ? AppColors.INCOGNITO_BG : AppColors.SURFACE)
        }

        // Main content area
        Stack() {
          // Home page view
          if (this.currentView === 'home') {
            Scroll() {
              HomePage({
                searchText: this.searchText,
                isIncognito: this.isIncognito,
                quickSites: this.quickSites,
                recentHistory: this.recentHistory,
                onSearch: (text: string) => {
                  this.handleSearch(text);
                },
                onTextChange: (text: string) => {
                  this.searchText = text;
                },
                onSiteTap: (url: string) => {
                  this.navigateToUrl(url);
                },
                onSiteLongPress: (siteId: string) => {
                  this.pendingDeleteSiteId = siteId;
                  this.showDeleteSiteDialog = true;
                },
                onHistoryItemTap: (url: string) => {
                  this.navigateToUrl(url);
                }
              })
            }
            .scrollable(ScrollDirection.Vertical)
            .width('100%')
            .layoutWeight(1)
          }

          // WebView browser view
          if (this.currentView === 'browser') {
            Web({ src: this.pageUrl, controller: this.webController })
              .width('100%')
              .layoutWeight(1)
              .javaScriptAccess(this.dataManager.settings.enableJavaScript)
              .domStorageAccess(true)
              .mixedMode(MixedMode.Compatible)
              .onPageBegin((event) => {
                if (event !== undefined && event.url !== undefined) {
                  this.isLoading = true;
                  this.pageUrl = event.url;
                  this.searchText = event.url;
                }
              })
              .onPageEnd((event) => {
                if (event !== undefined && event.url !== undefined) {
                  this.isLoading = false;
                  this.loadProgress = 100;
                  this.pageUrl = event.url;
                  this.searchText = event.url;

                  // Update navigation state
                  try {
                    this.canGoBack = this.webController.accessBackward();
                    this.canGoForward = this.webController.accessForward();
                  } catch (e) {
                    // Ignore
                  }

                  // Update tab and history
                  this.dataManager.updateActiveTab(this.pageUrl, this.pageTitle);
                  this.dataManager.addHistoryRecord(this.pageUrl, this.pageTitle, 'browse');
                }
              })
              .onProgressChange((event) => {
                if (event !== undefined) {
                  this.loadProgress = event.newProgress;
                }
              })
              .onTitleReceive((event) => {
                if (event !== undefined && event.title !== undefined) {
                  this.pageTitle = event.title;
                  this.dataManager.updateActiveTab(this.pageUrl, this.pageTitle);
                }
              })
              .onErrorReceive((event) => {
                this.isLoading = false;
              })
          }
        }
        .layoutWeight(1)
        .width('100%')

        // Bottom toolbar
        BrowserToolbar({
          canGoBack: this.canGoBack,
          canGoForward: this.canGoForward,
          tabCount: this.tabCount,
          isIncognito: this.isIncognito,
          onBack: () => {
            if (this.canGoBack) {
              try {
                this.webController.backward();
              } catch (e) {
                // Ignore
              }
            }
          },
          onForward: () => {
            if (this.canGoForward) {
              try {
                this.webController.forward();
              } catch (e) {
                // Ignore
              }
            }
          },
          onHome: () => {
            this.goHome();
          },
          onTabs: () => {
            this.goToTabList();
          },
          onMenu: () => {
            this.showMenu = !this.showMenu;
          }
        })
      }
      .width('100%')
      .height('100%')

      // Menu panel overlay
      if (this.showMenu) {
        MenuPanel({
          isIncognito: this.isIncognito,
          onNewTab: () => {
            this.createNewTab(false);
          },
          onNewIncognitoTab: () => {
            this.createNewTab(true);
          },
          onHistory: () => {
            this.goToHistory();
          },
          onSettings: () => {
            this.goToSettings();
          },
          onClose: () => {
            this.showMenu = false;
          }
        })
      }

      // Delete site confirmation dialog
      if (this.showDeleteSiteDialog) {
        Stack() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#66000000')
            .onClick(() => {
              this.showDeleteSiteDialog = false;
            })

          Column() {
            Text('删除此快捷方式？')
              .fontSize(AppDimens.FONT_LG)
              .fontWeight(FontWeight.Medium)
              .fontColor(AppColors.TEXT_PRIMARY)
              .margin({ top: AppDimens.PADDING_XL, bottom: AppDimens.PADDING_LG })

            Row() {
              Button('取消')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.TEXT_SECONDARY)
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .onClick(() => {
                  this.showDeleteSiteDialog = false;
                })

              Button('删除')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.ERROR)
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .onClick(() => {
                  this.dataManager.removeQuickSite(this.pendingDeleteSiteId);
                  this.quickSites = [...this.dataManager.quickSites];
                  this.showDeleteSiteDialog = false;
                })
            }
            .width('100%')
            .padding({ bottom: AppDimens.PADDING_MD })
          }
          .width('75%')
          .borderRadius(AppDimens.BORDER_RADIUS_LG)
          .backgroundColor(AppColors.SURFACE)
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isIncognito ? AppColors.INCOGNITO_BG : AppColors.BACKGROUND)
  }
}
