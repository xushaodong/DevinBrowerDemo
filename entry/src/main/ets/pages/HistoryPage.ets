/**
 * Nova Browser - History Page
 * Displays browsing and search history with options to delete individual
 * records or clear all history.
 */

import { router } from '@kit.ArkUI';
import { HistoryItem } from '../model/BrowserModels';
import { BrowserDataManager } from '../common/BrowserDataManager';
import { AppColors, AppDimens, UrlUtils } from '../common/Constants';

@Entry
@Component
struct HistoryPage {
  /** All history items */
  @State historyItems: HistoryItem[] = [];
  /** Whether to show clear all confirmation dialog */
  @State showClearDialog: boolean = false;
  /** Current filter: 'all' | 'browse' | 'search' */
  @State currentFilter: string = 'all';

  /** Data manager singleton */
  private dataManager: BrowserDataManager = BrowserDataManager.getInstance();

  aboutToAppear(): void {
    this.loadHistory();
  }

  /**
   * Load history from data manager with current filter applied.
   */
  private loadHistory(): void {
    if (this.currentFilter === 'all') {
      this.historyItems = [...this.dataManager.history];
    } else {
      this.historyItems = this.dataManager.history.filter(
        (item: HistoryItem) => item.historyType === this.currentFilter
      );
    }
  }

  /**
   * Delete a single history item.
   */
  private deleteItem(itemId: string): void {
    this.dataManager.deleteHistoryItem(itemId);
    this.loadHistory();
  }

  /**
   * Clear all history records.
   */
  private clearAllHistory(): void {
    this.dataManager.clearAllHistory();
    this.historyItems = [];
    this.showClearDialog = false;
  }

  /**
   * Navigate to a URL from history.
   */
  private openHistoryUrl(url: string): void {
    const activeTab = this.dataManager.getActiveTab();
    if (activeTab !== null) {
      activeTab.url = url;
    }
    router.back();
  }

  @Builder
  FilterTab(label: string, filterValue: string) {
    Column() {
      Text(label)
        .fontSize(AppDimens.FONT_MD)
        .fontColor(this.currentFilter === filterValue ? AppColors.PRIMARY : AppColors.TEXT_SECONDARY)
        .fontWeight(this.currentFilter === filterValue ? FontWeight.Bold : FontWeight.Normal)
        .padding({
          left: AppDimens.PADDING_LG,
          right: AppDimens.PADDING_LG,
          top: AppDimens.PADDING_SM,
          bottom: AppDimens.PADDING_SM
        })

      if (this.currentFilter === filterValue) {
        Divider()
          .width(40)
          .strokeWidth(2)
          .color(AppColors.PRIMARY)
      }
    }
    .onClick(() => {
      this.currentFilter = filterValue;
      this.loadHistory();
    })
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
              router.back();
            })

          Text('历史记录')
            .fontSize(AppDimens.FONT_XL)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.TEXT_PRIMARY)

          Blank()

          // Clear all button
          if (this.historyItems.length > 0) {
            Text('清空')
              .fontSize(AppDimens.FONT_MD)
              .fontColor(AppColors.ERROR)
              .padding(AppDimens.PADDING_MD)
              .onClick(() => {
                this.showClearDialog = true;
              })
          }
        }
        .width('100%')
        .height(AppDimens.TOOLBAR_HEIGHT)
        .padding({ left: AppDimens.PADDING_SM, right: AppDimens.PADDING_SM })
        .backgroundColor(AppColors.SURFACE)

        // Filter tabs
        Row() {
          this.FilterTab('全部', 'all')
          this.FilterTab('浏览', 'browse')
          this.FilterTab('搜索', 'search')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .backgroundColor(AppColors.SURFACE)
        .border({
          width: { bottom: 0.5 },
          color: AppColors.DIVIDER
        })

        // History list
        if (this.historyItems.length === 0) {
          // Empty state
          Column() {
            Text('📋')
              .fontSize(48)
              .margin({ bottom: AppDimens.PADDING_LG })

            Text('暂无历史记录')
              .fontSize(AppDimens.FONT_LG)
              .fontColor(AppColors.TEXT_SECONDARY)
          }
          .width('100%')
          .layoutWeight(1)
          .justifyContent(FlexAlign.Center)
        } else {
          List() {
            ForEach(this.historyItems, (item: HistoryItem) => {
              ListItem() {
                Row() {
                  // Type icon
                  Column() {
                    Text(item.historyType === 'search' ? '🔍' : '🌐')
                      .fontSize(AppDimens.FONT_XL)
                  }
                  .width(40)
                  .height(40)
                  .justifyContent(FlexAlign.Center)
                  .borderRadius(20)
                  .backgroundColor(AppColors.ADDRESS_BAR_BG)
                  .margin({ right: AppDimens.PADDING_MD })

                  // History item info
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

                  // Time and delete
                  Column() {
                    Text(UrlUtils.formatTime(item.timestamp))
                      .fontSize(AppDimens.FONT_XS)
                      .fontColor(AppColors.TEXT_HINT)
                      .margin({ bottom: AppDimens.PADDING_XS })

                    Text('🗑️')
                      .fontSize(AppDimens.FONT_MD)
                      .onClick(() => {
                        this.deleteItem(item.id);
                      })
                  }
                  .alignItems(HorizontalAlign.End)
                }
                .width('100%')
                .padding({
                  left: AppDimens.PADDING_LG,
                  right: AppDimens.PADDING_LG,
                  top: AppDimens.PADDING_MD,
                  bottom: AppDimens.PADDING_MD
                })
                .onClick(() => {
                  this.openHistoryUrl(item.url);
                })
              }
            }, (item: HistoryItem) => item.id)
          }
          .width('100%')
          .layoutWeight(1)
          .divider({
            strokeWidth: 0.5,
            color: AppColors.DIVIDER,
            startMargin: 68,
            endMargin: AppDimens.PADDING_LG
          })
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor(AppColors.BACKGROUND)

      // Clear all confirmation dialog
      if (this.showClearDialog) {
        Stack() {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor('#66000000')
            .onClick(() => {
              this.showClearDialog = false;
            })

          Column() {
            Text('清空所有历史记录？')
              .fontSize(AppDimens.FONT_LG)
              .fontWeight(FontWeight.Medium)
              .fontColor(AppColors.TEXT_PRIMARY)
              .margin({ top: AppDimens.PADDING_XL, bottom: AppDimens.PADDING_SM })

            Text('此操作无法撤销')
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
                  this.showClearDialog = false;
                })

              Divider()
                .vertical(true)
                .height(AppDimens.MENU_ITEM_HEIGHT)
                .color(AppColors.DIVIDER)

              Button('清空')
                .fontSize(AppDimens.FONT_MD)
                .fontColor(AppColors.ERROR)
                .backgroundColor(Color.Transparent)
                .layoutWeight(1)
                .onClick(() => {
                  this.clearAllHistory();
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
