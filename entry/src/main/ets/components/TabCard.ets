/**
 * Nova Browser - Tab Card Component
 * Displays a single tab card in the tab list view.
 */

import { TabInfo } from '../model/BrowserModels';
import { AppColors, AppDimens, UrlUtils } from '../common/Constants';

@Component
export struct TabCard {
  @ObjectLink tab: TabInfo;
  onSelect: (tabId: string) => void = () => {};
  onClose: (tabId: string) => void = () => {};

  build() {
    Column() {
      // Tab header with close button
      Row() {
        // Incognito indicator
        if (this.tab.isIncognito) {
          Text('🕶️')
            .fontSize(AppDimens.FONT_SM)
            .margin({ right: AppDimens.PADDING_XS })
        }

        // Tab title
        Text(this.tab.title)
          .fontSize(AppDimens.FONT_SM)
          .fontColor(this.tab.isIncognito ? Color.White : AppColors.TEXT_PRIMARY)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)

        // Close button
        Text('✕')
          .fontSize(AppDimens.FONT_MD)
          .fontColor(this.tab.isIncognito ? '#AAAAAA' : AppColors.TEXT_SECONDARY)
          .padding(AppDimens.PADDING_XS)
          .onClick(() => {
            this.onClose(this.tab.id);
          })
      }
      .width('100%')
      .padding({
        left: AppDimens.PADDING_MD,
        right: AppDimens.PADDING_SM,
        top: AppDimens.PADDING_SM
      })

      // Tab content preview area
      Column() {
        if (this.tab.url.length > 0) {
          Text(UrlUtils.getDomain(this.tab.url))
            .fontSize(AppDimens.FONT_SM)
            .fontColor(this.tab.isIncognito ? '#AAAAAA' : AppColors.TEXT_SECONDARY)
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        } else {
          Text(this.tab.isIncognito ? '无痕标签页' : '新标签页')
            .fontSize(AppDimens.FONT_MD)
            .fontColor(this.tab.isIncognito ? '#888888' : AppColors.TEXT_HINT)
        }
      }
      .layoutWeight(1)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .padding({ left: AppDimens.PADDING_MD, right: AppDimens.PADDING_MD })
    }
    .width('100%')
    .height(AppDimens.TAB_CARD_HEIGHT)
    .borderRadius(AppDimens.BORDER_RADIUS_MD)
    .backgroundColor(this.tab.isIncognito ? AppColors.INCOGNITO_SURFACE : AppColors.SURFACE)
    .border({
      width: this.tab.isActive ? 2 : 0.5,
      color: this.tab.isActive ? AppColors.PRIMARY : AppColors.DIVIDER
    })
    .shadow({
      radius: 4,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 2
    })
    .onClick(() => {
      this.onSelect(this.tab.id);
    })
  }
}
