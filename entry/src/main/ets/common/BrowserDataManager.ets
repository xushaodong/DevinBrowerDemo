/**
 * Nova Browser - Data Manager
 * Singleton class that manages all browser data across pages.
 * Provides centralized data access for tabs, history, settings, and quick sites.
 */

import { TabInfo, HistoryItem, QuickSite, BrowserSettings } from '../model/BrowserModels';

export class BrowserDataManager {
  private static instance: BrowserDataManager | null = null;

  /** All open browser tabs */
  tabs: TabInfo[] = [];
  /** Index of the currently active tab */
  activeTabIndex: number = 0;
  /** Browsing and search history records */
  history: HistoryItem[] = [];
  /** Quick access sites displayed on the home page */
  quickSites: QuickSite[] = [];
  /** User browser settings */
  settings: BrowserSettings = new BrowserSettings();
  /** Auto-incrementing ID counter for unique identifiers */
  private nextId: number = 1;

  private constructor() {
    this.initDefaultQuickSites();
    this.addNewTab(false);
  }

  /**
   * Get the singleton instance.
   */
  static getInstance(): BrowserDataManager {
    if (BrowserDataManager.instance === null) {
      BrowserDataManager.instance = new BrowserDataManager();
    }
    return BrowserDataManager.instance;
  }

  /**
   * Generate a unique ID.
   */
  generateId(): string {
    const id = this.nextId.toString();
    this.nextId++;
    return id;
  }

  /**
   * Initialize default quick access sites.
   */
  private initDefaultQuickSites(): void {
    this.quickSites = [
      new QuickSite('qs_1', 'Google', 'https://www.google.com', 'G', '#4285F4', 0),
      new QuickSite('qs_2', 'Bing', 'https://www.bing.com', 'B', '#008373', 1),
      new QuickSite('qs_3', 'YouTube', 'https://www.youtube.com', 'Y', '#FF0000', 2),
      new QuickSite('qs_4', 'GitHub', 'https://www.github.com', 'GH', '#24292E', 3),
      new QuickSite('qs_5', 'Wikipedia', 'https://www.wikipedia.org', 'W', '#636466', 4),
      new QuickSite('qs_6', 'Twitter', 'https://www.x.com', 'X', '#1DA1F2', 5),
      new QuickSite('qs_7', 'Reddit', 'https://www.reddit.com', 'R', '#FF4500', 6),
      new QuickSite('qs_8', 'Zhihu', 'https://www.zhihu.com', '知', '#0066FF', 7)
    ];
  }

  /**
   * Add a new tab.
   * @param isIncognito Whether the tab is an incognito tab.
   * @returns The newly created tab.
   */
  addNewTab(isIncognito: boolean): TabInfo {
    const id = this.generateId();
    const title = isIncognito ? '无痕标签页' : '新标签页';
    const tab = new TabInfo(id, '', title, isIncognito);
    tab.isActive = true;

    // Deactivate all other tabs
    for (let i = 0; i < this.tabs.length; i++) {
      this.tabs[i].isActive = false;
    }

    this.tabs.push(tab);
    this.activeTabIndex = this.tabs.length - 1;
    return tab;
  }

  /**
   * Close a tab by ID.
   * @param tabId The ID of the tab to close.
   */
  closeTab(tabId: string): void {
    const index = this.tabs.findIndex((t: TabInfo) => t.id === tabId);
    if (index < 0 || this.tabs.length <= 1) {
      return;
    }

    const wasActive = this.tabs[index].isActive;

    // If closing an incognito tab, no need for special cleanup here
    // since incognito data is not persisted anyway

    this.tabs.splice(index, 1);

    if (wasActive) {
      // Activate the nearest tab
      const newIndex = Math.min(index, this.tabs.length - 1);
      this.activeTabIndex = newIndex;
      this.tabs[newIndex].isActive = true;
    } else if (index < this.activeTabIndex) {
      this.activeTabIndex--;
    }
  }

  /**
   * Switch to a specific tab by index.
   * @param index The index of the tab to activate.
   */
  switchToTab(index: number): void {
    if (index < 0 || index >= this.tabs.length) {
      return;
    }
    for (let i = 0; i < this.tabs.length; i++) {
      this.tabs[i].isActive = (i === index);
    }
    this.activeTabIndex = index;
  }

  /**
   * Get the currently active tab.
   * @returns The active tab, or null if no tabs exist.
   */
  getActiveTab(): TabInfo | null {
    if (this.tabs.length === 0) {
      return null;
    }
    return this.tabs[this.activeTabIndex];
  }

  /**
   * Update the active tab's URL and title.
   */
  updateActiveTab(url: string, title: string): void {
    const tab = this.getActiveTab();
    if (tab !== null) {
      tab.url = url;
      tab.title = title;
      tab.timestamp = Date.now();
    }
  }

  /**
   * Add a browsing history record (skips if the active tab is incognito).
   */
  addHistoryRecord(url: string, title: string, historyType: string): void {
    const activeTab = this.getActiveTab();
    if (activeTab !== null && activeTab.isIncognito) {
      return; // Don't save history for incognito tabs
    }

    const id = this.generateId();
    const item = new HistoryItem(id, url, title, historyType);
    this.history.unshift(item); // Most recent first

    // Limit history to 500 items
    if (this.history.length > 500) {
      this.history.splice(500);
    }
  }

  /**
   * Delete a single history record by ID.
   */
  deleteHistoryItem(itemId: string): void {
    const index = this.history.findIndex((h: HistoryItem) => h.id === itemId);
    if (index >= 0) {
      this.history.splice(index, 1);
    }
  }

  /**
   * Clear all history records.
   */
  clearAllHistory(): void {
    this.history.splice(0, this.history.length);
  }

  /**
   * Get recent history items (for home page display).
   * @param limit Maximum number of items to return.
   */
  getRecentHistory(limit: number): HistoryItem[] {
    return this.history.slice(0, Math.min(limit, this.history.length));
  }

  /**
   * Remove a quick site by ID.
   */
  removeQuickSite(siteId: string): void {
    const index = this.quickSites.findIndex((s: QuickSite) => s.id === siteId);
    if (index >= 0) {
      this.quickSites.splice(index, 1);
    }
  }

  /**
   * Get the search URL based on current settings.
   */
  getSearchUrl(query: string): string {
    const encodedQuery = encodeURIComponent(query);
    if (this.settings.searchEngine === 'Bing') {
      return 'https://www.bing.com/search?q=' + encodedQuery;
    }
    return 'https://www.google.com/search?q=' + encodedQuery;
  }

  /**
   * Get the total number of tabs.
   */
  getTabCount(): number {
    return this.tabs.length;
  }

  /**
   * Clean up all incognito tab data.
   */
  cleanIncognitoData(): void {
    const normalTabs = this.tabs.filter((t: TabInfo) => !t.isIncognito);
    if (normalTabs.length === 0) {
      // Ensure at least one normal tab exists
      this.tabs.splice(0, this.tabs.length);
      this.addNewTab(false);
    } else {
      this.tabs.splice(0, this.tabs.length);
      for (const tab of normalTabs) {
        this.tabs.push(tab);
      }
      this.activeTabIndex = 0;
      this.tabs[0].isActive = true;
    }
  }
}
