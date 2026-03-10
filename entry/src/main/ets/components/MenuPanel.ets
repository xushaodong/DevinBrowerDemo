/**
 * Nova Browser - Menu Panel Component
 * Overlay menu providing access to browser features and settings.
 */

import { AppColors, AppDimens } from '../common/Constants';

@Component
export struct MenuPanel {
  @Prop isIncognito: boolean = false;
  onNewTab: () => void = () => {};
  onNewIncognitoTab: () => void = () => {};
  onHistory: () => void = () => {};
  onSettings: () => void = () => {};
  onClose: () => void = () => {};

  @Builder
  MenuItem(icon: string, label: string, action: () => void) {
    Row() {
      Text(icon)
        .fontSize(AppDimens.FONT_XL)
        .width(32)

      Text(label)
        .fontSize(AppDimens.FONT_LG)
        .fontColor(this.isIncognito ? Color.White : AppColors.TEXT_PRIMARY)
        .layoutWeight(1)
    }
    .width('100%')
    .height(AppDimens.MENU_ITEM_HEIGHT)
    .padding({ left: AppDimens.PADDING_LG, right: AppDimens.PADDING_LG })
    .onClick(() => {
      action();
    })
  }

  build() {
    Stack() {
      // Semi-transparent background overlay
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#66000000')
        .onClick(() => {
          this.onClose();
        })

      // Menu content panel
      Column() {
        // Menu header
        Row() {
          Text('菜单')
            .fontSize(AppDimens.FONT_XL)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isIncognito ? Color.White : AppColors.TEXT_PRIMARY)

          Blank()

          Text('✕')
            .fontSize(AppDimens.FONT_XXL)
            .fontColor(AppColors.TEXT_SECONDARY)
            .onClick(() => {
              this.onClose();
            })
        }
        .width('100%')
        .padding({
          left: AppDimens.PADDING_LG,
          right: AppDimens.PADDING_LG,
          top: AppDimens.PADDING_LG,
          bottom: AppDimens.PADDING_MD
        })

        Divider()
          .color(this.isIncognito ? '#555555' : AppColors.DIVIDER)

        // Menu items
        this.MenuItem('➕', '新建标签页', this.onNewTab)

        this.MenuItem('🕶️', '新建无痕标签页', this.onNewIncognitoTab)

        Divider()
          .color(this.isIncognito ? '#555555' : AppColors.DIVIDER)
          .margin({ left: AppDimens.PADDING_LG, right: AppDimens.PADDING_LG })

        this.MenuItem('📋', '历史记录', this.onHistory)

        Divider()
          .color(this.isIncognito ? '#555555' : AppColors.DIVIDER)
          .margin({ left: AppDimens.PADDING_LG, right: AppDimens.PADDING_LG })

        this.MenuItem('⚙️', '设置', this.onSettings)
      }
      .width('85%')
      .borderRadius(AppDimens.BORDER_RADIUS_LG)
      .backgroundColor(this.isIncognito ? AppColors.INCOGNITO_SURFACE : AppColors.SURFACE)
      .margin({ bottom: 80 })
      .shadow({
        radius: 20,
        color: '#33000000',
        offsetX: 0,
        offsetY: -4
      })
    }
    .width('100%')
    .height('100%')
    .alignContent(Alignment.Bottom)
  }
}
