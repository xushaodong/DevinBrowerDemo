/**
 * Nova Browser - Settings Page
 * Provides user configuration options for search engine, privacy,
 * cache management, and app information.
 */

import { router } from '@kit.ArkUI';
import { webview } from '@kit.ArkWeb';
import { BrowserDataManager } from '../common/BrowserDataManager';
import { AppColors, AppDimens } from '../common/Constants';

// ─────────────────────────────────────────────
// SettingsItem 子组件（用 @BuilderParam 代替函数参数）
// ─────────────────────────────────────────────
@Component
struct SettingsItem {
  /** 主标签文字 */
  label: string = '';
  /** 副标签描述，为空则不显示 */
  description: string = '';

  /**
   * 右侧内容插槽，由父组件通过 @Builder 传入。
   * 默认为空，防止未传时报错。
   */
  @BuilderParam rightContent: () => void = this.defaultBuilder;

  @Builder
  defaultBuilder() {}

  build() {
    Row() {
      Column() {
        Text(this.label)
          .fontSize(AppDimens.FONT_MD)
          .fontColor(AppColors.TEXT_PRIMARY)

        if (this.description.length > 0) {
          Text(this.description)
            .fontSize(AppDimens.FONT_SM)
            .fontColor(AppColors.TEXT_SECONDARY)
            .margin({ top: 2 })
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      // 渲染右侧插槽
      this.rightContent()
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
}

// ─────────────────────────────────────────────
// 主页面
// ─────────────────────────────────────────────
@Entry
@Component
struct SettingsPage {
  @State searchEngine: string = 'Google';
  @State enableCookies: boolean = true;
  @State enableJavaScript: boolean = true;
  @State enableHttpsFirst: boolean = true;
  @State showClearCacheDialog: boolean = false;
  @State showClearHistoryDialog: boolean = false;
  @State showSearchEngineSelector: boolean = false;
  @State appVersion: string = '1.0.0';

  private dataManager: BrowserDataManager = BrowserDataManager.getInstance();

  aboutToAppear(): void {
    this.searchEngine = this.dataManager.settings.searchEngine;
    this.enableCookies = this.dataManager.settings.enableCookies;
    this.enableJavaScript = this.dataManager.settings.enableJavaScript;
    this.enableHttpsFirst = this.dataManager.settings.enableHttpsFirst;
    this.appVersion = this.dataManager.settings.appVersion;
  }

  private saveSettings(): void {
    this.dataManager.settings.searchEngine = this.searchEngine;
    this.dataManager.settings.enableCookies = this.enableCookies;
    this.dataManager.settings.enableJavaScript = this.enableJavaScript;
    this.dataManager.settings.enableHttpsFirst = this.enableHttpsFirst;
  }

  // ── Section 标题 ──────────────────────────
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

  // ── 右侧插槽：搜索引擎选择器入口 ──────────
  @Builder
  SearchEngineRight() {
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
  }

  // ── 右侧插槽：Cookie Toggle ───────────────
  @Builder
  CookieToggleRight() {
    Toggle({ type: ToggleType.Switch, isOn: this.enableCookies })
      .selectedColor(AppColors.PRIMARY)
      .onChange((isOn: boolean) => {
        this.enableCookies = isOn;
        this.saveSettings();
      })
  }

  // ── 右侧插槽：JavaScript Toggle ──────────
  @Builder
  JavaScriptToggleRight() {
    Toggle({ type: ToggleType.Switch, isOn: this.enableJavaScript })
      .selectedColor(AppColors.PRIMARY)
      .onChange((isOn: boolean) => {
        this.enableJavaScript = isOn;
        this.saveSettings();
      })
  }

  // ── 右侧插槽：HTTPS 优先 Toggle ───────────
  @Builder
  HttpsToggleRight() {
    Toggle({ type: ToggleType.Switch, isOn: this.enableHttpsFirst })
      .selectedColor(AppColors.PRIMARY)
      .onChange((isOn: boolean) => {
        this.enableHttpsFirst = isOn;
        this.saveSettings();
      })
  }

  // ── 右侧插槽：版本号 ──────────────────────
  @Builder
  VersionRight() {
    Text('V' + this.appVersion)
      .fontSize(AppDimens.FONT_MD)
      .fontColor(AppColors.TEXT_SECONDARY)
  }

  // ── 右侧插槽：应用名称 ────────────────────
  @Builder
  AppNameRight() {
    Text('Nova Browser')
      .fontSize(AppDimens.FONT_MD)
      .fontColor(AppColors.TEXT_SECONDARY)
  }

  // ── 右侧插槽：平台 ────────────────────────
  @Builder
  PlatformRight() {
    Text('HarmonyOS')
      .fontSize(AppDimens.FONT_MD)
      .fontColor(AppColors.TEXT_SECONDARY)
  }

  // ── 搜索引擎选择弹窗 ──────────────────────
  @Builder
  SearchEngineSelectorDialog() {
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

        // Google
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

        // Bing
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

        Column().height(AppDimens.PADDING_LG)
      }
      .width('75%')
      .borderRadius(AppDimens.BORDER_RADIUS_LG)
      .backgroundColor(AppColors.SURFACE)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
  }

  // ── 清除缓存确认弹窗 ──────────────────────
  @Builder
  ClearCacheDialog() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#66000000')
        .onClick(() => { this.showClearCacheDialog = false; })

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
            .onClick(() => { this.showClearCacheDialog = false; })

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
              try {
                webview.WebviewController.clearPrefetchedResource([]);
                webview.WebviewController.clearIntelligentTrackingPreventionBypassingList();
              } catch (e) {}
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

  // ── 清除历史记录确认弹窗 ──────────────────
  @Builder
  ClearHistoryDialog() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#66000000')
        .onClick(() => { this.showClearHistoryDialog = false; })

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
            .onClick(() => { this.showClearHistoryDialog = false; })

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

  build() {
    Stack() {
      Column() {
        // ── Header ──────────────────────────
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
        .border({ width: { bottom: 0.5 }, color: AppColors.DIVIDER })

        // ── 内容列表 ─────────────────────────
        Scroll() {
          Column() {
            // 搜索
            this.SettingsSection('搜索')
            SettingsItem({
              label: '默认搜索引擎',
              description: '选择搜索时使用的引擎',
              rightContent: () => { this.SearchEngineRight(); }
            })

            // 隐私与安全
            this.SettingsSection('隐私与安全')
            SettingsItem({
              label: 'Cookie管理',
              description: '控制网站Cookie存储',
              rightContent: () => { this.CookieToggleRight(); }
            })
            Divider()
              .color(AppColors.DIVIDER)
              .margin({ left: AppDimens.PADDING_LG })

            SettingsItem({
              label: 'JavaScript',
              description: '启用网页JavaScript执行',
              rightContent: () => { this.JavaScriptToggleRight(); }
            })
            Divider()
              .color(AppColors.DIVIDER)
              .margin({ left: AppDimens.PADDING_LG })

            SettingsItem({
              label: 'HTTPS优先',
              description: '优先使用HTTPS安全连接',
              rightContent: () => { this.HttpsToggleRight(); }
            })

            // 数据管理
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
              left: AppDimens.PADDING_LG, right: AppDimens.PADDING_LG,
              top: AppDimens.PADDING_MD, bottom: AppDimens.PADDING_MD
            })
            .backgroundColor(AppColors.SURFACE)
            .onClick(() => { this.showClearCacheDialog = true; })

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
              left: AppDimens.PADDING_LG, right: AppDimens.PADDING_LG,
              top: AppDimens.PADDING_MD, bottom: AppDimens.PADDING_MD
            })
            .backgroundColor(AppColors.SURFACE)
            .onClick(() => { this.showClearHistoryDialog = true; })

            // 关于
            this.SettingsSection('关于')
            SettingsItem({ label: '版本号', description: '',
              rightContent: () => { this.VersionRight(); } })
            Divider()
              .color(AppColors.DIVIDER)
              .margin({ left: AppDimens.PADDING_LG })

            SettingsItem({ label: '应用名称', description: '',
              rightContent: () => { this.AppNameRight(); } })
            Divider()
              .color(AppColors.DIVIDER)
              .margin({ left: AppDimens.PADDING_LG })

            SettingsItem({ label: '平台', description: '',
              rightContent: () => { this.PlatformRight(); } })

            Column().height(40)
          }
        }
        .scrollable(ScrollDirection.Vertical)
        .layoutWeight(1)
        .width('100%')
        .backgroundColor(AppColors.BACKGROUND)
      }
      .width('100%')
      .height('100%')

      // ── 弹窗层 ────────────────────────────
      if (this.showSearchEngineSelector) {
        this.SearchEngineSelectorDialog()
      }
      if (this.showClearCacheDialog) {
        this.ClearCacheDialog()
      }
      if (this.showClearHistoryDialog) {
        this.ClearHistoryDialog()
      }
    }
    .width('100%')
    .height('100%')
  }
}