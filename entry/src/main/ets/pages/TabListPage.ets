/**
 * Nova Browser - Tab List Page
 * Displays all open tabs in a grid layout.
 * Supports creating, switching, and closing tabs.
 */

import { router } from '@kit.ArkUI';
import { TabInfo } from '../model/BrowserModels';
import { BrowserDataManager } from '../common/BrowserDataManager';
import { AppColors, AppDimens } from '../common/Constants';
import { TabCard } from '../components/TabCard';

@Entry
@Component
struct TabListPage {
  /** All open tabs */
  @State tabs: TabInfo[] = [];
  /** Total tab count */
  @State tabCount: number = 0;
  /** Whether any incognito tab is present */
  @State hasIncognito: boolean = false;

  /** Data manager singleton */
  private dataManager: BrowserDataManager = BrowserDataManager.getInstance();

  aboutToAppear(): void {
    this.syncTabs();
  }

  /**
   * Sync tabs from the data manager.
   */
  private syncTabs(): void {
    this.tabs = this.dataManager.tabs;
    this.tabCount = this.dataManager.getTabCount();
    this.hasIncognito = this.tabs.some((t: TabInfo) => t.isIncognito);
  }

  /**
   * Select and switch to a specific tab.
   */
  private selectTab(tabId: string): void {
    const index = this.tabs.findIndex((t: TabInfo) => t.id === tabId);
    if (index >= 0) {
      this.dataManager.switchToTab(index);
      router.back();
    }
  }

  /**
   * Close a specific tab.
   */
  private closeTab(tabId: string): void {
    if (this.tabs.length <= 1) {
      // If it's the last tab, go back to the browser with a new tab
      return;
    }
    this.dataManager.closeTab(tabId);
    this.syncTabs();
  }

  /**
   * Create a new normal tab.
   */
  private createNewTab(): void {
    this.dataManager.addNewTab(false);
    router.back();
  }

  /**
   * Create a new incognito tab.
   */
  private createIncognitoTab(): void {
    this.dataManager.addNewTab(true);
    router.back();
  }

  build() {
    Column() {
      // Header
      Row() {
        // Back button
        Text('←')
          .fontSize(AppDimens.FONT_XXL)
          .fontColor(AppColors.TEXT_PRIMARY)
          .padding(AppDimens.PADDING_MD)
          .onClick(() => {
            router.back();
          })

        Text('标签页')
          .fontSize(AppDimens.FONT_XL)
          .fontWeight(FontWeight.Bold)
          .fontColor(AppColors.TEXT_PRIMARY)

        Text(' (' + this.tabCount.toString() + ')')
          .fontSize(AppDimens.FONT_MD)
          .fontColor(AppColors.TEXT_SECONDARY)

        Blank()

        // New tab button
        Text('＋')
          .fontSize(AppDimens.FONT_XXL)
          .fontColor(AppColors.PRIMARY)
          .padding(AppDimens.PADDING_MD)
          .onClick(() => {
            this.createNewTab();
          })
      }
      .width('100%')
      .height(AppDimens.TOOLBAR_HEIGHT)
      .padding({ left: AppDimens.PADDING_SM, right: AppDimens.PADDING_SM })
      .backgroundColor(AppColors.SURFACE)
      .border({
        width: { bottom: 0.5 },
        color: AppColors.DIVIDER
      })

      // Tab grid
      Scroll() {
        Column() {
          // Normal tabs section
          if (this.tabs.some((t: TabInfo) => !t.isIncognito)) {
            Column() {
              Grid() {
                ForEach(
                  this.tabs.filter((t: TabInfo) => !t.isIncognito),
                  (tab: TabInfo) => {
                    GridItem() {
                      TabCard({
                        tab: tab,
                        onSelect: (tabId: string) => {
                          this.selectTab(tabId);
                        },
                        onClose: (tabId: string) => {
                          this.closeTab(tabId);
                        }
                      })
                    }
                  },
                  (tab: TabInfo) => tab.id
                )
              }
              .columnsTemplate('1fr 1fr')
              .columnsGap(AppDimens.PADDING_MD)
              .rowsGap(AppDimens.PADDING_MD)
              .padding(AppDimens.PADDING_LG)
              .width('100%')
            }
          }

          // Incognito tabs section
          if (this.hasIncognito) {
            Column() {
              Row() {
                Text('🕶️')
                  .fontSize(AppDimens.FONT_LG)
                  .margin({ right: AppDimens.PADDING_SM })

                Text('无痕标签页')
                  .fontSize(AppDimens.FONT_MD)
                  .fontWeight(FontWeight.Medium)
                  .fontColor(AppColors.TEXT_SECONDARY)
              }
              .width('100%')
              .padding({
                left: AppDimens.PADDING_LG,
                top: AppDimens.PADDING_SM,
                bottom: AppDimens.PADDING_SM
              })

              Grid() {
                ForEach(
                  this.tabs.filter((t: TabInfo) => t.isIncognito),
                  (tab: TabInfo) => {
                    GridItem() {
                      TabCard({
                        tab: tab,
                        onSelect: (tabId: string) => {
                          this.selectTab(tabId);
                        },
                        onClose: (tabId: string) => {
                          this.closeTab(tabId);
                        }
                      })
                    }
                  },
                  (tab: TabInfo) => tab.id
                )
              }
              .columnsTemplate('1fr 1fr')
              .columnsGap(AppDimens.PADDING_MD)
              .rowsGap(AppDimens.PADDING_MD)
              .padding({
                left: AppDimens.PADDING_LG,
                right: AppDimens.PADDING_LG,
                bottom: AppDimens.PADDING_LG
              })
              .width('100%')
            }
            .backgroundColor('#F0F0F0')
            .borderRadius(AppDimens.BORDER_RADIUS_MD)
            .margin({
              left: AppDimens.PADDING_MD,
              right: AppDimens.PADDING_MD,
              bottom: AppDimens.PADDING_MD
            })
          }
        }
      }
      .scrollable(ScrollDirection.Vertical)
      .layoutWeight(1)
      .width('100%')
      .backgroundColor(AppColors.BACKGROUND)

      // Bottom action area
      Column() {
        Divider().color(AppColors.DIVIDER)

        Row() {
          // New incognito tab button
          Button('🕶️ 新建无痕标签页')
            .fontSize(AppDimens.FONT_MD)
            .fontColor(AppColors.TEXT_PRIMARY)
            .backgroundColor(AppColors.ADDRESS_BAR_BG)
            .borderRadius(AppDimens.BORDER_RADIUS_XL)
            .height(40)
            .onClick(() => {
              this.createIncognitoTab();
            })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding(AppDimens.PADDING_MD)
      }
      .backgroundColor(AppColors.SURFACE)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.BACKGROUND)
  }
}
