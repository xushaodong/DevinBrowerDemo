/**
 * Nova Browser - Site Card Component
 * Displays a quick-access website card with icon and name.
 */

import { QuickSite } from '../model/BrowserModels';
import { AppColors, AppDimens } from '../common/Constants';

@Component
export struct SiteCard {
  @ObjectLink site: QuickSite;
  onTap: (url: string) => void = () => {};
  onLongPress: (siteId: string) => void = () => {};

  build() {
    Column() {
      // Site icon circle
      Stack() {
        Circle()
          .width(AppDimens.SITE_ICON_SIZE)
          .height(AppDimens.SITE_ICON_SIZE)
          .fill(this.site.iconColor)
          .opacity(0.15)

        Text(this.site.iconText)
          .fontSize(AppDimens.FONT_XL)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.site.iconColor)
      }
      .width(AppDimens.SITE_ICON_SIZE)
      .height(AppDimens.SITE_ICON_SIZE)

      // Site name
      Text(this.site.name)
        .fontSize(AppDimens.FONT_SM)
        .fontColor(AppColors.TEXT_SECONDARY)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: AppDimens.PADDING_SM })
    }
    .width(AppDimens.SITE_CARD_SIZE)
    .height(90)
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.onTap(this.site.url);
    })
    .gesture(
      LongPressGesture()
        .onAction(() => {
          this.onLongPress(this.site.id);
        })
    )
  }
}
