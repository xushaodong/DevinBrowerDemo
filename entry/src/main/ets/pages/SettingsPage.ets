/**
 * Nova Browser - Settings Page
 * Provides user configuration options for search engine, privacy,
 * cache management, and app information.
 */

import { router } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { BrowserDataManager } from '../common/BrowserDataManager';
import { AppColors, AppDimens } from '../common/Constants';

@Entry
@Component
struct SettingsPage {
  /** Currently selected search engine */
  @State searchEngine: string = 'Google';
  /** Whether cookies are enabled */
  @State enableCookies: boolean = true;
  /** Whether JavaScript is enabled */
  @State enableJavaScript: boolean = true;
  /** Whether HTTPS-first mode is enabled */
  @State enableHttpsFirst: boolean = true;
  /** Whether to show clear cache confirmation */
  @State showClearCacheDialog: boolean = false;
  /** Whether to show clear history confirmation */
  @State showClearHistoryDialog: boolean = false;
  /** Whether to show search engine selector */
  @State showSearchEngineSelector: boolean = false;
  /** App version string */
  @State appVersion: string = '1.0.0';

  /** Data manager singleton */
  private dataManager: BrowserDataManager = BrowserDataManager.getInstance();

  aboutToAppear(): void {
    this.searchEngine = this.dataManager.settings.searchEngine;
    this.enableCookies = this.dataManager.settings.enableCookies;
    this.enableJavaScript = this.dataManager.settings.enableJavaScript;
    this.enableHttpsFirst = this.dataManager.settings.enableHttpsFirst;
    this.appVersion = this.dataManager.settings.appVersion;
  }

  /**
   * Save settings back to data manager.
   */
  private saveSettings(): void {
    this.dataManager.settings.searchEngine = this.searchEngine;
    this.dataManager.settings.enableCookies = this.enableCookies;
    this.dataManager.settings.enableJavaScript = this.enableJavaScript;
    this.dataManager.settings.enableHttpsFirst = this.enableHttpsFirst;
  }

  @Builder
  SettingsSection(title: string) {
    Text(title)
      .fontSize(AppDimens.FONT_SM)
      .fontWeight(FontWeight.Medium)
      .fontColor(AppColors.PRIMARY)
      .width('100%')
      .padding({
        left: AppDimens.PADDING_LG,
        top: AppDimens.PADDING_LG,
        bottom: AppDimens.PADDING_SM
      })
  }

  @Builder
  SettingsItem(label: string, description: string, rightContent: () => void) {
    Row() {
      Column() {
        Text(label)
          .fontSize(AppDimens.FONT_MD)
          .fontColor(AppColors.TEXT_PRIMARY)

        if (description.length > 0) {
          Text(description)
            .fontSize(AppDimens.FONT_SM)
            .fontColor(AppColors.TEXT_SECONDARY)
            .margin({ top: 2 })
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      rightContent()
    }
    .width('100%')
    .padding({
      left: AppDimens.PADDING_LG,
      right: AppDimens.PADDING_LG,
      top: AppDimens.PADDING_MD,
      bottom: AppDimens.PADDING_MD
    })
    .backgroundColor(AppColors.SURFACE)
  }

  build() {
    Stack() {
      Column() {
        // Header
        Row() {
          Text('←')
            .fontSize(AppDimens.FONT_XXL)
            .fontColor(AppColors.TEXT_PRIMARY)
            .padding(AppDimens.PADDING_MD)
            .onClick(() => {
              this.saveSettings();
              router.back();
            })

          Text('设置')
            .fontSize(AppDimens.FONT_XL)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.TEXT_PRIMARY)

          Blank()
        }
        .width('100%')
        .height(AppDimens.TOOLBAR_HEIGHT)
        .padding({ left: AppDimens.PADDING_SM, right: AppDimens.PADDING_SM })
        .backgroundColor(AppColors.SURFACE)
        .border({
          width: { bottom: 0.5 },
          color: AppColors.DIVIDER
        })

        // Settings content
        Scroll() {
          Column() {
            // Search section
            this.SettingsSection('搜索')

            this.SettingsItem('默认搜索引擎', '选择搜索时使用的引擎', () => {
              Row() {
                Text(this.searchEngine)
                  .fontSize(AppDimens.FONT_MD)
                  .fontColor(AppColors.TEXT_SECONDARY)

                Text(' ▸')
                  .fontSize(AppDimens.FONT_MD)
                  .fontColor(AppColors.TEXT_HINT)
              }
              .onClick(() => {
                this.showSearchEngineSelector = true;
              })
            })

            // Privacy section
            this.SettingsSection('隐私与安全')

            this.SettingsItem('Cookie管理', '控制网站Cookie存储', () => {
              Toggle({ type: ToggleType.Switch, isOn: this.enableCookies })
                .selectedColor(AppColors.PRIMARY)
                .onChange((isOn: boolean) => {
                  this.enableCookies = isOn;
                  this.saveSettings();
                })
            })

            Divider()
              .color(AppColors.DIVIDER)
              .margin({ left: AppDimens.PADDING_LG })

            this.SettingsItem('JavaScript', '启用网页JavaScript执行', () => {
              Toggle({ type: ToggleType.Switch, isOn: this.enableJavaScript })
                .selectedColor(AppColors.PRIMARY)
                .onChange((isOn: boolean) => {
                  this.enableJavaScript = isOn;
                  this.saveSettings();
                })
            })

            Divider()
              .color(AppColors.DIVIDER)
              .margin({ left: AppDimens.PADDING_LG })

            this.SettingsItem('HTTPS优先', '优先使用HTTPS安全连接', () => {
              Toggle({ type: ToggleType.Switch, isOn: this.enableHttpsFirst })
                .selectedColor(AppColors.PRIMARY)
                .onChange((isOn: boolean) => {
                  this.enableHttpsFirst = isOn;
                  this.saveSettings();
                })
            })

            // Data management section
            this.SettingsSection('数据管理')

            Row() {
              Text('清除缓存')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.TEXT_PRIMARY)
                .layoutWeight(1)

              Text('删除本地浏览缓存数据')
                .fontSize(AppDimens.FONT_SM)
                .fontColor(AppColors.TEXT_SECONDARY)
            }
            .width('100%')
            .padding({
              left: AppDimens.PADDING_LG,
              right: AppDimens.PADDING_LG,
              top: AppDimens.PADDING_MD,
              bottom: AppDimens.PADDING_MD
            })
            .backgroundColor(AppColors.SURFACE)
            .onClick(() => {
              this.showClearCacheDialog = true;
            })

            Divider()
              .color(AppColors.DIVIDER)
              .margin({ left: AppDimens.PADDING_LG })

            Row() {
              Text('清除历史记录')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.TEXT_PRIMARY)
                .layoutWeight(1)

              Text('删除所有浏览记录')
                .fontSize(AppDimens.FONT_SM)
                .fontColor(AppColors.TEXT_SECONDARY)
            }
            .width('100%')
            .padding({
              left: AppDimens.PADDING_LG,
              right: AppDimens.PADDING_LG,
              top: AppDimens.PADDING_MD,
              bottom: AppDimens.PADDING_MD
            })
            .backgroundColor(AppColors.SURFACE)
            .onClick(() => {
              this.showClearHistoryDialog = true;
            })

            // About section
            this.SettingsSection('关于')

            this.SettingsItem('版本号', '', () => {
              Text('V' + this.appVersion)
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.TEXT_SECONDARY)
            })

            Divider()
              .color(AppColors.DIVIDER)
              .margin({ left: AppDimens.PADDING_LG })

            this.SettingsItem('应用名称', '', () => {
              Text('Nova Browser')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.TEXT_SECONDARY)
            })

            Divider()
              .color(AppColors.DIVIDER)
              .margin({ left: AppDimens.PADDING_LG })

            this.SettingsItem('平台', '', () => {
              Text('HarmonyOS')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.TEXT_SECONDARY)
            })

            // Footer spacer
            Column()
              .height(40)
          }
        }
        .scrollable(ScrollDirection.Vertical)
        .layoutWeight(1)
        .width('100%')
        .backgroundColor(AppColors.BACKGROUND)
      }
      .width('100%')
      .height('100%')

      // Search engine selector dialog
      if (this.showSearchEngineSelector) {
        Stack() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#66000000')
            .onClick(() => {
              this.showSearchEngineSelector = false;
            })

          Column() {
            Text('选择搜索引擎')
              .fontSize(AppDimens.FONT_LG)
              .fontWeight(FontWeight.Medium)
              .fontColor(AppColors.TEXT_PRIMARY)
              .margin({ top: AppDimens.PADDING_XL, bottom: AppDimens.PADDING_LG })

            // Google option
            Row() {
              Text('G')
                .fontSize(AppDimens.FONT_LG)
                .fontWeight(FontWeight.Bold)
                .fontColor('#4285F4')
                .width(32)

              Text('Google')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.TEXT_PRIMARY)
                .layoutWeight(1)

              if (this.searchEngine === 'Google') {
                Text('✓')
                  .fontSize(AppDimens.FONT_LG)
                  .fontColor(AppColors.PRIMARY)
              }
            }
            .width('100%')
            .padding({
              left: AppDimens.PADDING_XL,
              right: AppDimens.PADDING_XL,
              top: AppDimens.PADDING_MD,
              bottom: AppDimens.PADDING_MD
            })
            .onClick(() => {
              this.searchEngine = 'Google';
              this.saveSettings();
              this.showSearchEngineSelector = false;
            })

            Divider()
              .color(AppColors.DIVIDER)
              .margin({ left: AppDimens.PADDING_XL, right: AppDimens.PADDING_XL })

            // Bing option
            Row() {
              Text('B')
                .fontSize(AppDimens.FONT_LG)
                .fontWeight(FontWeight.Bold)
                .fontColor('#008373')
                .width(32)

              Text('Bing')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.TEXT_PRIMARY)
                .layoutWeight(1)

              if (this.searchEngine === 'Bing') {
                Text('✓')
                  .fontSize(AppDimens.FONT_LG)
                  .fontColor(AppColors.PRIMARY)
              }
            }
            .width('100%')
            .padding({
              left: AppDimens.PADDING_XL,
              right: AppDimens.PADDING_XL,
              top: AppDimens.PADDING_MD,
              bottom: AppDimens.PADDING_MD
            })
            .onClick(() => {
              this.searchEngine = 'Bing';
              this.saveSettings();
              this.showSearchEngineSelector = false;
            })

            // Bottom padding
            Column()
              .height(AppDimens.PADDING_LG)
          }
          .width('75%')
          .borderRadius(AppDimens.BORDER_RADIUS_LG)
          .backgroundColor(AppColors.SURFACE)
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('100%')
      }

      // Clear cache confirmation dialog
      if (this.showClearCacheDialog) {
        Stack() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#66000000')
            .onClick(() => {
              this.showClearCacheDialog = false;
            })

          Column() {
            Text('清除缓存？')
              .fontSize(AppDimens.FONT_LG)
              .fontWeight(FontWeight.Medium)
              .fontColor(AppColors.TEXT_PRIMARY)
              .margin({ top: AppDimens.PADDING_XL, bottom: AppDimens.PADDING_SM })

            Text('将删除所有本地浏览缓存数据')
              .fontSize(AppDimens.FONT_SM)
              .fontColor(AppColors.TEXT_SECONDARY)
              .margin({ bottom: AppDimens.PADDING_LG })

            Divider().color(AppColors.DIVIDER)

            Row() {
              Button('取消')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.TEXT_SECONDARY)
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .onClick(() => {
                  this.showClearCacheDialog = false;
                })

              Divider()
                .vertical(true)
                .height(AppDimens.MENU_ITEM_HEIGHT)
                .color(AppColors.DIVIDER)

              Button('清除')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.ERROR)
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .onClick(() => {
                  // Clear WebView cache
                  try {
                    webview.WebviewController.clearHttpCache();
                  } catch (e) {
                    // Ignore errors
                  }
                  this.showClearCacheDialog = false;
                })
            }
            .width('100%')
          }
          .width('75%')
          .borderRadius(AppDimens.BORDER_RADIUS_LG)
          .backgroundColor(AppColors.SURFACE)
          .alignItems(HorizontalAlign.Center)
        }
        .width('100%')
        .height('100%')
      }

      // Clear history confirmation dialog
      if (this.showClearHistoryDialog) {
        Stack() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#66000000')
            .onClick(() => {
              this.showClearHistoryDialog = false;
            })

          Column() {
            Text('清除历史记录？')
              .fontSize(AppDimens.FONT_LG)
              .fontWeight(FontWeight.Medium)
              .fontColor(AppColors.TEXT_PRIMARY)
              .margin({ top: AppDimens.PADDING_XL, bottom: AppDimens.PADDING_SM })

            Text('将删除所有浏览和搜索记录')
              .fontSize(AppDimens.FONT_SM)
              .fontColor(AppColors.TEXT_SECONDARY)
              .margin({ bottom: AppDimens.PADDING_LG })

            Divider().color(AppColors.DIVIDER)

            Row() {
              Button('取消')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.TEXT_SECONDARY)
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .onClick(() => {
                  this.showClearHistoryDialog = false;
                })

              Divider()
                .vertical(true)
                .height(AppDimens.MENU_ITEM_HEIGHT)
                .color(AppColors.DIVIDER)

              Button('清除')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.ERROR)
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .onClick(() => {
                  this.dataManager.clearAllHistory();
                  this.showClearHistoryDialog = false;
                })
            }
            .width('100%')
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
  }
}
