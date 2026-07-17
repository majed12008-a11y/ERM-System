"""
RC2 Functional Closure — UI Evidence Screenshots
Phase 1+2: Fixed selectors, resilient waits, language-aware matching.

Login: #username, #password, button[type="submit"]
Post-login: navigate('/') → index route (Dashboard)
Language: Arabic default, so use Arabic text for section headings.
"""
from playwright.sync_api import sync_playwright, TimeoutError as PwTimeout
import os, sys, time

SCREENSHOTS_DIR = r'C:\ERM-System\docs\screenshots\rc2'
os.makedirs(SCREENSHOTS_DIR, exist_ok=True)

BASE = 'http://localhost:5173'
SHOT_NUM = [0]

def shot(page, name, label=''):
    SHOT_NUM[0] += 1
    path = os.path.join(SCREENSHOTS_DIR, f'{SHOT_NUM[0]:02d}-{name}.png')
    page.screenshot(path=path, full_page=True)
    print(f'  [{SHOT_NUM[0]:02d}] SAVED: {name} ({label})')
    return path

def safe_wait(page, timeout=5000):
    """Wait for network to settle, with timeout fallback."""
    try:
        page.wait_for_load_state('networkidle', timeout=timeout)
    except PwTimeout:
        pass
    page.wait_for_timeout(1000)

def find_and_click(page, selectors, description=''):
    """Try multiple selectors to find and click an element."""
    for sel in selectors:
        try:
            el = page.locator(sel).first
            if el.count() > 0 and el.is_visible(timeout=2000):
                el.scroll_into_view_if_needed()
                page.wait_for_timeout(300)
                el.click()
                print(f'  Clicked: {description} (selector: {sel})')
                return True
        except Exception:
            continue
    print(f'  NOT FOUND: {description}')
    return False

def find_visible_text(page, texts):
    """Find the first visible text from a list."""
    for t in texts:
        try:
            el = page.locator(f'text="{t}"').first
            if el.count() > 0 and el.is_visible(timeout=1000):
                return el
        except Exception:
            continue
    return None

def scroll_to_section(page, texts):
    """Scroll to find a section by text, return True if found."""
    for t in texts:
        try:
            el = page.locator(f'text="{t}"').first
            if el.count() > 0:
                el.scroll_into_view_if_needed()
                page.wait_for_timeout(500)
                return True
        except Exception:
            continue
    # Fallback: scroll to bottom
    page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
    page.wait_for_timeout(500)
    return False

def main():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        ctx = browser.new_context(viewport={'width': 1440, 'height': 900})
        page = ctx.new_page()

        # ═══════════════════════════════════════════════════════════
        # STEP 1: Login
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 1: Login ═══')
        page.goto(f'{BASE}/login')
        page.wait_for_load_state('networkidle')
        page.wait_for_timeout(1500)
        shot(page, 'login-page', 'Login form')

        page.fill('#username', 'admin')
        page.fill('#password', 'admin123')
        page.click('button[type="submit"]')

        try:
            page.wait_for_url(f'{BASE}/', timeout=15000)
            safe_wait(page)
            page.wait_for_timeout(2000)
            print('[LOGIN] Success')
        except PwTimeout:
            print(f'[LOGIN] FAILED — URL: {page.url}')
            page.screenshot(path=os.path.join(SCREENSHOTS_DIR, 'debug-login-fail.png'))
            browser.close()
            sys.exit(1)

        # ═══════════════════════════════════════════════════════════
        # STEP 2: Dashboard
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 2: Dashboard ═══')
        shot(page, 'dashboard', 'Admin Dashboard')

        # ═══════════════════════════════════════════════════════════
        # STEP 3: Application Detail + Template Actions
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 3: Application Detail ═══')
        page.goto(f'{BASE}/applications/110')
        safe_wait(page, 8000)
        page.wait_for_timeout(2000)
        shot(page, 'application-detail', 'App #110 DRAFT')

        # Scroll to document generation section (Arabic: توليد مستند / English: Generate Document)
        found = scroll_to_section(page, ['توليد مستند', 'Generate Document', 'generateDocument'])
        page.wait_for_timeout(500)
        shot(page, 'application-template-actions', 'Template Actions section')

        # ═══════════════════════════════════════════════════════════
        # STEP 4: Preview from Application
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 4: Preview from Application ═══')
        clicked = find_and_click(page, [
            'button:has-text("معاينة")',
            'button:has-text("Preview")',
            'button:has-text("preview")',
        ], 'Preview button')
        if clicked:
            page.wait_for_timeout(4000)
            shot(page, 'application-preview-modal', 'Preview modal')
            # Close modal
            find_and_click(page, [
                'button:has-text("×")',
                'button:has-text("إغلاق")',
                'button:has-text("Close")',
                '.fixed button:first-child',
            ], 'Close modal')
            page.wait_for_timeout(500)
        else:
            print('  Skipping preview modal (button not found)')

        # ═══════════════════════════════════════════════════════════
        # STEP 5: Template Library
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 5: Template Library ═══')
        page.goto(f'{BASE}/templates')
        safe_wait(page, 8000)
        page.wait_for_timeout(2000)
        shot(page, 'template-library', '12 templates')

        # ═══════════════════════════════════════════════════════════
        # STEP 6: Template Detail (certificate-approval)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 6: Template Detail ═══')
        page.goto(f'{BASE}/templates/4')
        safe_wait(page, 8000)
        page.wait_for_timeout(2000)
        shot(page, 'template-detail', 'certificate-approval')

        # ═══════════════════════════════════════════════════════════
        # STEP 7: Variable Inspector
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 7: Variable Inspector ═══')
        scroll_to_section(page, ['فاحص المتغيرات', 'Variable Inspector'])
        page.wait_for_timeout(500)
        shot(page, 'variable-inspector', 'Variable Inspector panel')

        # ═══════════════════════════════════════════════════════════
        # STEP 8: Template Preview Page
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 8: Template Preview Page ═══')
        page.goto(f'{BASE}/templates/preview/certificate-approval')
        safe_wait(page, 8000)
        page.wait_for_timeout(2000)
        shot(page, 'template-preview-page', 'certificate-approval preview')

        # ═══════════════════════════════════════════════════════════
        # STEP 9: Template Version Detail (APPROVED v4)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 9: Version Detail ═══')
        page.goto(f'{BASE}/templates/versions/4')
        safe_wait(page, 8000)
        page.wait_for_timeout(2000)
        shot(page, 'version-detail', 'v4 APPROVED')

        # ═══════════════════════════════════════════════════════════
        # STEP 10: Snapshots
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 10: Snapshot History ═══')
        scroll_to_section(page, ['سجل اللقطات', 'Snapshot History', 'snapshots'])
        page.wait_for_timeout(500)
        shot(page, 'snapshot-history', 'Snapshot History')

        # ═══════════════════════════════════════════════════════════
        # STEP 11: Render History
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 11: Render History ═══')
        scroll_to_section(page, ['سجل التوليد', 'Render History', 'renderHistory'])
        page.wait_for_timeout(500)
        shot(page, 'render-history', 'Render History')

        # ═══════════════════════════════════════════════════════════
        # STEP 12: Audit Trail
        # ═══════════════════════════════════════════════════════════
        print('\n═══ STEP 12: Audit Trail ═══')
        scroll_to_section(page, ['سجل التدقيق', 'Audit Trail', 'audit'])
        page.wait_for_timeout(500)
        shot(page, 'audit-trail', 'Audit History')

        browser.close()
        print(f'\n═══ COMPLETE — {SHOT_NUM[0]} screenshots ═══')
        print(f'Saved to: {SCREENSHOTS_DIR}')

if __name__ == '__main__':
    main()
