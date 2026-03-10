/**
 * Nova Browser - Home Page Component
 * Displays the browser's home screen with search, quick sites, and recent history.
 */

import { QuickSite, HistoryItem } from '../model/BrowserModels';
import { AppColors, AppDimens, UrlUtils } from '../common/Constants';
import { SearchBar } from './SearchBar';
import { SiteCard } from './SiteCard';

@Component
export struct HomePage {
  @Prop searchText: string = '';
  @Prop isIncognito: boolean = false;
  quickSites: QuickSite[] = [];
  recentHistory: HistoryItem[] = [];
  onSearch: (text: string) => void = () => {};
  onTextChange: (text: string) => void = () => {};
  onSiteTap: (url: string) => void = () => {};
  onSiteLongPress: (siteId: string) => void = () => {};
  onHistoryItemTap: (url: string) => void = () => {};

  build() {
    Column() {
      // Logo area
      Column() {
        Text('Nova')
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor(this.isIncognito ? Color.White : AppColors.PRIMARY)
          .margin({ bottom: 4 })

        Text('Browser')
          .fontSize(AppDimens.FONT_MD)
          .fontColor(this.isIncognito ? '#AAAAAA' : AppColors.TEXT_SECONDARY)
      }
      .margin({ top: 60, bottom: AppDimens.PADDING_XL })

      // Search bar
      SearchBar({
        searchText: this.searchText,
        isIncognito: this.isIncognito,
        onSearch: this.onSearch,
        onTextChange: this.onTextChange,
        onCommit: () => {}
      })
      .margin({
        left: AppDimens.PADDING_LG,
        right: AppDimens.PADDING_LG,
        bottom: AppDimens.PADDING_XL
      })

      // Incognito notice
      if (this.isIncognito) {
        Row() {
          Text('🕶️')
            .fontSize(AppDimens.FONT_LG)
            .margin({ right: AppDimens.PADDING_SM })

          Text('无痕浏览模式 · 不保存历史记录和Cookie')
            .fontSize(AppDimens.FONT_SM)
            .fontColor('#AAAAAA')
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ bottom: AppDimens.PADDING_LG })
      }

      // Quick sites grid
      if (this.quickSites.length > 0 && !this.isIncognito) {
        Column() {
          Text('常用网站')
            .fontSize(AppDimens.FONT_MD)
            .fontWeight(FontWeight.Medium)
            .fontColor(AppColors.TEXT_SECONDARY)
            .width('100%')
            .margin({ bottom: AppDimens.PADDING_MD })
            .padding({ left: AppDimens.PADDING_LG })

          Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.SpaceAround }) {
            ForEach(this.quickSites, (site: QuickSite) => {
              SiteCard({
                site: site,
                onTap: this.onSiteTap,
                onLongPress: this.onSiteLongPress
              })
              .margin({ bottom: AppDimens.PADDING_MD })
            }, (site: QuickSite) => site.id)
          }
          .width('100%')
          .padding({ left: AppDimens.PADDING_SM, right: AppDimens.PADDING_SM })
        }
        .margin({ bottom: AppDimens.PADDING_LG })
      }

      // Recent history
      if (this.recentHistory.length > 0 && !this.isIncognito) {
        Column() {
          Text('最近访问')
            .fontSize(AppDimens.FONT_MD)
            .fontWeight(FontWeight.Medium)
            .fontColor(AppColors.TEXT_SECONDARY)
            .width('100%')
            .margin({ bottom: AppDimens.PADDING_SM })
            .padding({ left: AppDimens.PADDING_LG })

          ForEach(this.recentHistory, (item: HistoryItem) => {
            Row() {
              Column() {
                Text(item.title)
                  .fontSize(AppDimens.FONT_MD)
                  .fontColor(AppColors.TEXT_PRIMARY)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })

                Text(UrlUtils.getDomain(item.url))
                  .fontSize(AppDimens.FONT_SM)
                  .fontColor(AppColors.TEXT_SECONDARY)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                  .margin({ top: 2 })
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)

              Text(UrlUtils.formatTime(item.timestamp))
                .fontSize(AppDimens.FONT_XS)
                .fontColor(AppColors.TEXT_HINT)
                .margin({ left: AppDimens.PADDING_SM })
            }
            .width('100%')
            .padding({
              left: AppDimens.PADDING_LG,
              right: AppDimens.PADDING_LG,
              top: AppDimens.PADDING_MD,
              bottom: AppDimens.PADDING_MD
            })
            .onClick(() => {
              this.onHistoryItemTap(item.url);
            })
          }, (item: HistoryItem) => item.id)
        }
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(this.isIncognito ? AppColors.INCOGNITO_BG : AppColors.BACKGROUND)
  }
}
