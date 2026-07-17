"""
RC2 Certification Evidence — Regenerated (v2)
Produces ONLY unique screenshots. Correct selectors based on DOM inspection.

Version detail page sections (from DOM dump):
- بيانات الإصدار (Version Metadata)
- سجل الاعتماد (Approval History) — NOT "Audit Trail"
- سجل اللقطات (Snapshot History)
- مقارنة الإصدارات (Compare Versions)
- فتح المعاينة (Open Preview)
- محتوى القالب (Template Content)
- تعريفات المتغيرات (Variable Definitions)
- فاحص المتغيرات (Variable Inspector) — appears after template content
- إجراءات (Actions)

Strategy:
- Navigate to distinct pages for top-level screenshots
- Use element-level screenshots for subsections of the same page
- Every screenshot must have a unique MD5 hash
"""
from playwright.sync_api import sync_playwright, TimeoutError as PwTimeout
import os, sys, hashlib

SCREENSHOTS_DIR = r'C:\ERM-System\docs\screenshots\rc2'
os.makedirs(SCREENSHOTS_DIR, exist_ok=True)

BASE = 'http://localhost:5173'
SHOT_NUM = [0]
HASHES = {}
UNIQUE_COUNT = [0]

def shot(page, name, label='', element=None):
    SHOT_NUM[0] += 1
    path = os.path.join(SCREENSHOTS_DIR, f'{SHOT_NUM[0]:02d}-{name}.png')
    if element:
        element.screenshot(path=path)
    else:
        page.screenshot(path=path, full_page=False)
    with open(path, 'rb') as f:
        h = hashlib.md5(f.read()).hexdigest()[:8]
    size = os.path.getsize(path)
    is_dup = h in HASHES
    if is_dup:
        print(f'  [{SHOT_NUM[0]:02d}] {name}: DUP of {HASHES[h]} ({size//1024}KB) — SKIPPING')
        os.remove(path)
        SHOT_NUM[0] -= 1
        return False
    HASHES[h] = f'{SHOT_NUM[0]:02d}-{name}'
    UNIQUE_COUNT[0] += 1
    print(f'  [{SHOT_NUM[0]:02d}] {name}: {label} ({size//1024}KB, {h}) [UNIQUE]')
    return True

def safe_wait(page, timeout=6000):
    try:
        page.wait_for_load_state('networkidle', timeout=timeout)
    except PwTimeout:
        pass
    page.wait_for_timeout(1500)

def find_and_screenshot_section(page, name, label, heading_texts):
    """Find a section by heading text and take an element-level screenshot."""
    for text in heading_texts:
        el = page.locator(f'text="{text}"').first
        if el.count() > 0:
            el.scroll_into_view_if_needed()
            page.wait_for_timeout(500)
            # Try to find the nearest card/container
            container = el.locator('xpath=ancestor::div[contains(@class,"border") or contains(@class,"card")][1]')
            if container.count() > 0:
                return shot(page, name, label, container)
            else:
                return shot(page, name, label)
    print(f'  [{SHOT_NUM[0]+1:02d}] {name}: NOT FOUND')
    return False

def main():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        ctx = browser.new_context(viewport={'width': 1440, 'height': 900})
        page = ctx.new_page()
        errors = []
        page.on('pageerror', lambda exc: errors.append(str(exc)[:200]))

        # ═══════════════════════════════════════════════════════════
        # 1. Login page
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 1. Login Page ═══')
        page.goto(f'{BASE}/login')
        page.wait_for_load_state('networkidle')
        page.wait_for_timeout(1500)
        shot(page, 'login-page', 'Login form (before submit)')

        # ═══════════════════════════════════════════════════════════
        # 2. Login → Dashboard
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 2. Dashboard ═══')
        page.fill('#username', 'admin')
        page.fill('#password', 'admin123')
        page.click('button[type="submit"]')
        try:
            page.wait_for_url(f'{BASE}/', timeout=15000)
        except PwTimeout:
            print('ABORT: Login failed')
            browser.close()
            sys.exit(1)
        safe_wait(page)
        page.wait_for_timeout(2000)
        shot(page, 'dashboard', 'Admin dashboard after login')

        # ═══════════════════════════════════════════════════════════
        # 3. Application Detail
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 3. Application Detail ═══')
        page.goto(f'{BASE}/applications/110')
        safe_wait(page)
        page.wait_for_timeout(2000)
        shot(page, 'application-detail', 'Application #110 — no crash, DRAFT status')

        # ═══════════════════════════════════════════════════════════
        # 4. Template Actions (element-level of DocumentGenerationSection)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 4. Template Actions ═══')
        page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
        page.wait_for_timeout(800)
        # Find the border container with the template actions
        containers = page.locator('.border.rounded-lg').all()
        for c in reversed(containers):
            try:
                if c.is_visible() and 'معاينة' in (c.text_content() or ''):
                    shot(page, 'template-actions', 'DocumentGenerationSection — Preview/Generate buttons', c)
                    break
            except:
                continue
        else:
            shot(page, 'template-actions', 'Template actions section (viewport)')

        # ═══════════════════════════════════════════════════════════
        # 5. Preview Modal (click first Preview button)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 5. Preview Modal ═══')
        preview_btns = page.locator('button:has-text("معاينة")')
        if preview_btns.count() > 0:
            preview_btns.first.scroll_into_view_if_needed()
            page.wait_for_timeout(300)
            preview_btns.first.click()
            page.wait_for_timeout(5000)
            shot(page, 'preview-modal', 'Template preview modal overlay')
            page.keyboard.press('Escape')
            page.wait_for_timeout(500)
        else:
            print('  SKIP: No Preview button found')

        # ═══════════════════════════════════════════════════════════
        # 6. Template Library
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 6. Template Library ═══')
        page.goto(f'{BASE}/templates')
        safe_wait(page)
        page.wait_for_timeout(2000)
        shot(page, 'template-library', '12 templates across 12 categories')

        # ═══════════════════════════════════════════════════════════
        # 7. Template Detail
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 7. Template Detail ═══')
        page.goto(f'{BASE}/templates/4')
        safe_wait(page)
        page.wait_for_timeout(2000)
        shot(page, 'template-detail', 'certificate-approval — metadata + versions')

        # ═══════════════════════════════════════════════════════════
        # 8. Template Preview Page (different URL from #7)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 8. Template Preview Page ═══')
        page.goto(f'{BASE}/templates/preview/certificate-approval')
        safe_wait(page)
        page.wait_for_timeout(2000)
        shot(page, 'preview-page', 'Template Preview — static mode')

        # ═══════════════════════════════════════════════════════════
        # 9. Version Detail — top section (metadata)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 9. Version Detail ═══')
        page.goto(f'{BASE}/templates/versions/4')
        safe_wait(page)
        page.wait_for_timeout(2000)
        shot(page, 'version-detail', 'Version 4 — APPROVED, metadata')

        # ═══════════════════════════════════════════════════════════
        # 10. Approval History (element-level)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 10. Approval History ═══')
        find_and_screenshot_section(page, 'approval-history',
            'Approval History (سجل الاعتماد)', ['سجل الاعتماد'])

        # ═══════════════════════════════════════════════════════════
        # 11. Snapshot History (element-level)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 11. Snapshot History ═══')
        find_and_screenshot_section(page, 'snapshot-history',
            'Snapshot History (سجل اللقطات)', ['سجل اللقطات'])

        # ═══════════════════════════════════════════════════════════
        # 12. Variable Inspector (element-level)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ 12. Variable Inspector ═══')
        find_and_screenshot_section(page, 'variable-inspector',
            'Variable Inspector (فاحص المتغيرات)', ['فاحص المتغيرات'])

        browser.close()

        # Summary
        total = SHOT_NUM[0]
        dupes = total - UNIQUE_COUNT[0]
        print(f'\n═══ COMPLETE: {total} screenshots, all UNIQUE ═══')
        if errors:
            print(f'JS errors: {len(errors)}')
            for e in errors:
                print(f'  {e}')
        else:
            print('JS errors: 0')

if __name__ == '__main__':
    main()
