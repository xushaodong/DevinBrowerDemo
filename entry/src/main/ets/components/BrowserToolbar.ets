/**
 * Nova Browser - Browser Toolbar Component
 * Bottom navigation bar with back, forward, home, tabs, and menu controls.
 */

import { AppColors, AppDimens } from '../common/Constants';

@Component
export struct BrowserToolbar {
  @Prop canGoBack: boolean = false;
  @Prop canGoForward: boolean = false;
  @Prop tabCount: number = 1;
  @Prop isIncognito: boolean = false;
  onBack: () => void = () => {};
  onForward: () => void = () => {};
  onHome: () => void = () => {};
  onTabs: () => void = () => {};
  onMenu: () => void = () => {};

  @Builder
  ToolbarButton(icon: string, enabled: boolean, action: () => void) {
    Column() {
      Text(icon)
        .fontSize(22)
        .fontColor(enabled ?
          (this.isIncognito ? Color.White : AppColors.ICON_DEFAULT) :
          (this.isIncognito ? '#666666' : '#C0C0C0'))
    }
    .width(48)
    .height(48)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      if (enabled) {
        action();
      }
    })
  }

  build() {
    Row() {
      // Back button
      this.ToolbarButton('◀', this.canGoBack, this.onBack)

      Blank()

      // Forward button
      this.ToolbarButton('▶', this.canGoForward, this.onForward)

      Blank()

      // Home button
      this.ToolbarButton('🏠', true, this.onHome)

      Blank()

      // Tab count button
      Column() {
        Stack() {
          Text('⧉')
            .fontSize(22)
            .fontColor(this.isIncognito ? Color.White : AppColors.ICON_DEFAULT)

          Text(this.tabCount.toString())
            .fontSize(9)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isIncognito ? Color.White : AppColors.ICON_DEFAULT)
            .margin({ top: 1 })
        }
      }
      .width(48)
      .height(48)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        this.onTabs();
      })

      Blank()

      // Menu button
      this.ToolbarButton('☰', true, this.onMenu)
    }
    .width('100%')
    .height(AppDimens.TOOLBAR_HEIGHT)
    .padding({ left: AppDimens.PADDING_LG, right: AppDimens.PADDING_LG })
    .backgroundColor(this.isIncognito ? AppColors.INCOGNITO_BG : AppColors.TOOLBAR_BG)
    .border({
      width: { top: 0.5 },
      color: this.isIncognito ? '#555555' : AppColors.DIVIDER
    })
  }
}
