/**
 * Nova Browser - Application Constants
 * Central location for all constant values used in the app.
 */

/**
 * Search engine URL templates.
 */
export class SearchEngines {
  static readonly GOOGLE: string = 'https://www.google.com/search?q=';
  static readonly BING: string = 'https://www.bing.com/search?q=';

  /**
   * Get search URL for the given engine and query.
   */
  static getSearchUrl(engine: string, query: string): string {
    const encodedQuery = encodeURIComponent(query);
    if (engine === 'Bing') {
      return SearchEngines.BING + encodedQuery;
    }
    return SearchEngines.GOOGLE + encodedQuery;
  }
}

/**
 * Application color constants.
 */
export class AppColors {
  static readonly PRIMARY: string = '#4285F4';
  static readonly PRIMARY_DARK: string = '#3367D6';
  static readonly SECONDARY: string = '#34A853';
  static readonly BACKGROUND: string = '#F5F5F5';
  static readonly SURFACE: string = '#FFFFFF';
  static readonly TEXT_PRIMARY: string = '#202124';
  static readonly TEXT_SECONDARY: string = '#5F6368';
  static readonly TEXT_HINT: string = '#9AA0A6';
  static readonly DIVIDER: string = '#E0E0E0';
  static readonly INCOGNITO_BG: string = '#3C4043';
  static readonly INCOGNITO_SURFACE: string = '#525355';
  static readonly ERROR: string = '#EA4335';
  static readonly TOOLBAR_BG: string = '#FAFAFA';
  static readonly ADDRESS_BAR_BG: string = '#F1F3F4';
  static readonly ICON_DEFAULT: string = '#5F6368';
  static readonly ICON_ACTIVE: string = '#4285F4';
}

/**
 * Layout dimension constants.
 */
export class AppDimens {
  static readonly TOOLBAR_HEIGHT: number = 56;
  static readonly ADDRESS_BAR_HEIGHT: number = 44;
  static readonly SITE_CARD_SIZE: number = 72;
  static readonly SITE_ICON_SIZE: number = 48;
  static readonly TAB_CARD_HEIGHT: number = 180;
  static readonly MENU_ITEM_HEIGHT: number = 48;
  static readonly BORDER_RADIUS_SM: number = 8;
  static readonly BORDER_RADIUS_MD: number = 12;
  static readonly BORDER_RADIUS_LG: number = 16;
  static readonly BORDER_RADIUS_XL: number = 24;
  static readonly PADDING_XS: number = 4;
  static readonly PADDING_SM: number = 8;
  static readonly PADDING_MD: number = 12;
  static readonly PADDING_LG: number = 16;
  static readonly PADDING_XL: number = 24;
  static readonly FONT_XS: number = 10;
  static readonly FONT_SM: number = 12;
  static readonly FONT_MD: number = 14;
  static readonly FONT_LG: number = 16;
  static readonly FONT_XL: number = 18;
  static readonly FONT_XXL: number = 20;
  static readonly FONT_TITLE: number = 24;
}

/**
 * URL utilities.
 */
export class UrlUtils {
  /**
   * Check if input is a valid URL.
   */
  static isUrl(input: string): boolean {
    const trimmed = input.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return true;
    }
    // Check for domain-like patterns
    const domainPattern = /^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?(\.[a-zA-Z]{2,})+/;
    return domainPattern.test(trimmed);
  }

  /**
   * Normalize URL by adding protocol if needed.
   */
  static normalizeUrl(input: string): string {
    const trimmed = input.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    return 'https://' + trimmed;
  }

  /**
   * Extract display-friendly domain from URL.
   */
  static getDomain(url: string): string {
    try {
      let cleanUrl = url;
      if (cleanUrl.startsWith('http://')) {
        cleanUrl = cleanUrl.substring(7);
      } else if (cleanUrl.startsWith('https://')) {
        cleanUrl = cleanUrl.substring(8);
      }
      const slashIndex = cleanUrl.indexOf('/');
      if (slashIndex > 0) {
        cleanUrl = cleanUrl.substring(0, slashIndex);
      }
      if (cleanUrl.startsWith('www.')) {
        cleanUrl = cleanUrl.substring(4);
      }
      return cleanUrl;
    } catch (e) {
      return url;
    }
  }

  /**
   * Format timestamp to display string.
   */
  static formatTime(timestamp: number): string {
    const date = new Date(timestamp);
    const now = new Date();
    const diffMs = now.getTime() - date.getTime();
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMs / 3600000);
    const diffDays = Math.floor(diffMs / 86400000);

    if (diffMins < 1) {
      return '刚刚';
    } else if (diffMins < 60) {
      return diffMins + '分钟前';
    } else if (diffHours < 24) {
      return diffHours + '小时前';
    } else if (diffDays < 7) {
      return diffDays + '天前';
    } else {
      const month = (date.getMonth() + 1).toString().padStart(2, '0');
      const day = date.getDate().toString().padStart(2, '0');
      return month + '-' + day;
    }
  }
}
