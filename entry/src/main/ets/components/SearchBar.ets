/**
 * Nova Browser - Search Bar Component
 * Provides search input with URL detection and search engine integration.
 */

import { AppColors, AppDimens } from '../common/Constants';

@Component
export struct SearchBar {
  @Prop searchText: string = '';
  @Prop isIncognito: boolean = false;
  onSearch: (text: string) => void = () => {};
  onTextChange: (text: string) => void = () => {};
  onCommit: () => void = () => {};

  build() {
    Row() {
      // Search icon
      Text('🔍')
        .fontSize(AppDimens.FONT_LG)
        .margin({ left: AppDimens.PADDING_MD, right: AppDimens.PADDING_SM })

      // Search input
      TextInput({ text: this.searchText, placeholder: '搜索或输入网址' })
        .layoutWeight(1)
        .height(40)
        .backgroundColor(Color.Transparent)
        .fontSize(AppDimens.FONT_MD)
        .fontColor(this.isIncognito ? Color.White : AppColors.TEXT_PRIMARY)
        .placeholderColor(this.isIncognito ? '#AAAAAA' : AppColors.TEXT_HINT)
        .caretColor(AppColors.PRIMARY)
        .maxLines(1)
        .enterKeyType(EnterKeyType.Search)
        .onChange((value: string) => {
          this.onTextChange(value);
        })
        .onSubmit(() => {
          this.onSearch(this.searchText);
        })
        .onClick(() => {
          this.onCommit();
        })

      // Clear button
      if (this.searchText.length > 0) {
        Text('✕')
          .fontSize(AppDimens.FONT_LG)
          .fontColor(AppColors.TEXT_SECONDARY)
          .margin({ right: AppDimens.PADDING_MD })
          .onClick(() => {
            this.onTextChange('');
          })
      }
    }
    .width('100%')
    .height(AppDimens.ADDRESS_BAR_HEIGHT)
    .borderRadius(AppDimens.BORDER_RADIUS_XL)
    .backgroundColor(this.isIncognito ? AppColors.INCOGNITO_SURFACE : AppColors.ADDRESS_BAR_BG)
  }
}
