/**
 * Nova Browser - Data Models
 * Defines all data structures used throughout the browser application.
 */

/**
 * Represents a browser tab with its state.
 */
@Observed
export class TabInfo {
  id: string;
  url: string;
  title: string;
  isIncognito: boolean;
  timestamp: number;
  isActive: boolean;

  constructor(
    id: string,
    url: string = '',
    title: string = '新标签页',
    isIncognito: boolean = false
  ) {
    this.id = id;
    this.url = url;
    this.title = title;
    this.isIncognito = isIncognito;
    this.timestamp = Date.now();
    this.isActive = false;
  }
}

/**
 * Represents a history record for browsing or search.
 */
@Observed
export class HistoryItem {
  id: string;
  url: string;
  title: string;
  timestamp: number;
  historyType: string; // 'browse' | 'search'

  constructor(
    id: string,
    url: string,
    title: string,
    historyType: string = 'browse'
  ) {
    this.id = id;
    this.url = url;
    this.title = title;
    this.timestamp = Date.now();
    this.historyType = historyType;
  }
}

/**
 * Represents a quick-access website on the home page.
 */
@Observed
export class QuickSite {
  id: string;
  name: string;
  url: string;
  iconText: string;
  iconColor: string;
  order: number;

  constructor(
    id: string,
    name: string,
    url: string,
    iconText: string,
    iconColor: string,
    order: number
  ) {
    this.id = id;
    this.name = name;
    this.url = url;
    this.iconText = iconText;
    this.iconColor = iconColor;
    this.order = order;
  }
}

/**
 * Browser settings configuration.
 */
@Observed
export class BrowserSettings {
  searchEngine: string; // 'Google' | 'Bing'
  enableCookies: boolean;
  enableJavaScript: boolean;
  enableHttpsFirst: boolean;
  appVersion: string;

  constructor() {
    this.searchEngine = 'Google';
    this.enableCookies = true;
    this.enableJavaScript = true;
    this.enableHttpsFirst = true;
    this.appVersion = '1.0.0';
  }
}
