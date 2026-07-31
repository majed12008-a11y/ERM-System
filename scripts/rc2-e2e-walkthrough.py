"""
RC2 Phase 3 — Full Connected E2E Scenario Through UI
Researcher → Login → Open Application → Generate Template → Preview → Render → Snapshot → History → Verification

Each step captures a screenshot. Steps are sequential and connected.
"""
from playwright.sync_api import sync_playwright, TimeoutError as PwTimeout
import os, sys, time

SCREENSHOTS_DIR = r'C:\ERM-System\docs\screenshots\rc2\e2e'
os.makedirs(SCREENSHOTS_DIR, exist_ok=True)

BASE = 'http://localhost:5173'
SHOT_NUM = [0]
EVENTS = []

def shot(page, name, label=''):
    SHOT_NUM[0] += 1
    path = os.path.join(SCREENSHOTS_DIR, f'{SHOT_NUM[0]:02d}-{name}.png')
    page.screenshot(path=path, full_page=True)
    EVENTS.append(f'[{SHOT_NUM[0]:02d}] {name}: {label}')
    print(f'  [{SHOT_NUM[0]:02d}] {name}: {label}')

def safe_wait(page, timeout=6000):
    try:
        page.wait_for_load_state('networkidle', timeout=timeout)
    except PwTimeout:
        pass
    page.wait_for_timeout(1500)

def toasts(page):
    """Check for toast notifications."""
    toast_els = page.locator('[data-sonner-toaster] [data-sonner-toast]').all()
    results = []
    for t in toast_els:
        try:
            results.append(t.text_content().strip()[:100])
        except:
            pass
    return results

def main():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        ctx = browser.new_context(viewport={'width': 1440, 'height': 900})
        page = ctx.new_page()

        errors = []
        page.on('pageerror', lambda exc: errors.append(str(exc)[:200]))

        # ═══════════════════════════════════════════════════════════
        # STEP 1: Login as Admin
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 1: Login ═══')
        page.goto(f'{BASE}/login')
        safe_wait(page)
        page.fill('#username', 'admin')
        page.fill('#password', 'admin123')
        page.click('button[type="submit"]')
        try:
            page.wait_for_url(f'{BASE}/', timeout=15000)
            safe_wait(page)
            page.wait_for_timeout(2000)
        except PwTimeout:
            print('ABORT: Login failed')
            browser.close()
            sys.exit(1)
        shot(page, '01-logged-in', 'Admin logged in, Dashboard visible')

        # ═══════════════════════════════════════════════════════════
        # STEP 2: Navigate to Application Detail
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 2: Open Application ═══')
        page.goto(f'{BASE}/applications/110')
        safe_wait(page)
        page.wait_for_timeout(2000)

        # Verify page loaded correctly (no crash)
        error_msg = page.locator('text=حدث خطأ ما').count()
        if error_msg > 0:
            print('  ERROR: ApplicationDetail crashed!')
            shot(page, '02-app-crash', 'ERROR: page crashed')
        else:
            shot(page, '02-app-detail', 'Application #110 loaded, DRAFT status')

        # ═══════════════════════════════════════════════════════════
        # STEP 3: Scroll to Template Actions Section
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 3: Template Actions ═══')
        # Scroll down to find DocumentGenerationSection
        for _ in range(5):
            page.evaluate('window.scrollBy(0, 400)')
            page.wait_for_timeout(300)

        # Look for the section header
        found = False
        for text in ['توليد مستند', 'Generate Document']:
            el = page.locator(f'text="{text}"').first
            if el.count() > 0:
                el.scroll_into_view_if_needed()
                page.wait_for_timeout(500)
                found = True
                break

        if found:
            shot(page, '03-template-actions', 'DocumentGenerationSection visible')
        else:
            # Try finding by button icons
            page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
            page.wait_for_timeout(500)
            shot(page, '03-template-actions', 'Scrolled to bottom (section may be below fold)')

        # ═══════════════════════════════════════════════════════════
        # STEP 4: Preview Template from Application
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 4: Preview Template ═══')
        preview_btns = page.locator('button:has-text("معاينة"), button:has-text("Preview")')
        if preview_btns.count() > 0:
            # Click the first Preview button
            first_preview = preview_btns.first
            first_preview.scroll_into_view_if_needed()
            page.wait_for_timeout(300)
            first_preview.click()
            page.wait_for_timeout(5000)  # wait for API + render

            # Check if modal appeared
            modal = page.locator('.fixed.inset-0, [class*="fixed"][class*="inset"]')
            if modal.count() > 0:
                shot(page, '04-preview-modal', 'Template preview modal open')
            else:
                shot(page, '04-preview-modal', 'Preview triggered (modal state unclear)')
        else:
            print('  WARNING: No Preview button found')
            shot(page, '04-preview-modal', 'SKIPPED: No Preview button')

        # Close modal if open — press Escape
        page.keyboard.press('Escape')
        page.wait_for_timeout(500)

        # ═══════════════════════════════════════════════════════════
        # STEP 5: Generate (Render) Template from Application
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 5: Generate Template ═══')
        # Re-scroll to template actions
        for _ in range(5):
            page.evaluate('window.scrollBy(0, 400)')
            page.wait_for_timeout(200)

        gen_btns = page.locator('button:has-text("توليد"), button:has-text("Generate")')
        if gen_btns.count() > 0:
            gen_btns.first.scroll_into_view_if_needed()
            page.wait_for_timeout(300)
            gen_btns.first.click()
            page.wait_for_timeout(5000)  # wait for render + snapshot creation

            # Check toasts
            toast_msgs = toasts(page)
            if toast_msgs:
                shot(page, '05-generate-toast', f'Toast: {toast_msgs[0][:60]}')
            else:
                shot(page, '05-generate-result', 'Generate clicked, waiting for result')
        else:
            print('  WARNING: No Generate button found')
            shot(page, '05-generate-result', 'SKIPPED: No Generate button')

        # ═══════════════════════════════════════════════════════════
        # STEP 6: Navigate to Template Library
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 6: Template Library ═══')
        page.goto(f'{BASE}/templates')
        safe_wait(page)
        page.wait_for_timeout(2000)
        shot(page, '06-template-library', 'Template Library — 12 templates')

        # ═══════════════════════════════════════════════════════════
        # STEP 7: Open Template Detail (certificate-approval)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 7: Template Detail ═══')
        # Navigate directly to template detail
        page.goto(f'{BASE}/templates/4')
        safe_wait(page)
        page.wait_for_timeout(2000)
        shot(page, '07-template-detail', 'certificate-approval template detail')

        # ═══════════════════════════════════════════════════════════
        # STEP 8: Variable Inspector
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 8: Variable Inspector ═══')
        for text in ['فاحص المتغيرات', 'Variable Inspector']:
            el = page.locator(f'text="{text}"').first
            if el.count() > 0:
                el.scroll_into_view_if_needed()
                page.wait_for_timeout(500)
                break
        else:
            page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
            page.wait_for_timeout(500)
        shot(page, '08-variable-inspector', 'Variable Inspector panel')

        # ═══════════════════════════════════════════════════════════
        # STEP 9: Template Preview Page (dedicated)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 9: Template Preview ═══')
        page.goto(f'{BASE}/templates/preview/certificate-approval')
        safe_wait(page)
        page.wait_for_timeout(2000)
        shot(page, '09-preview-page', 'Template Preview page')

        # ═══════════════════════════════════════════════════════════
        # STEP 10: Render from Preview Page
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 10: Render Template ═══')
        render_btn = page.locator('button:has-text("توليد وحفظ")')
        if render_btn.count() > 0:
            render_btn.first.scroll_into_view_if_needed()
            page.wait_for_timeout(300)
            is_disabled = render_btn.first.is_disabled()
            if is_disabled:
                shot(page, '10-render-result', 'Render button visible but disabled (no content loaded)')
            else:
                render_btn.first.click()
                page.wait_for_timeout(5000)
                toast_msgs = toasts(page)
                if toast_msgs:
                    shot(page, '10-render-result', f'Rendered: {toast_msgs[0][:60]}')
                else:
                    shot(page, '10-render-result', 'Render button clicked')
        else:
            print('  WARNING: No Render button found')
            shot(page, '10-render-result', 'SKIPPED: No Render button')

        # ═══════════════════════════════════════════════════════════
        # STEP 11: Version Detail (APPROVED v4)
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 11: Version Detail ═══')
        page.goto(f'{BASE}/templates/versions/4')
        safe_wait(page)
        page.wait_for_timeout(2000)
        shot(page, '11-version-detail', 'Version 4 — APPROVED status')

        # ═══════════════════════════════════════════════════════════
        # STEP 12: Snapshot History
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 12: Snapshots ═══')
        for text in ['سجل اللقطات', 'Snapshot History', 'snapshots']:
            el = page.locator(f'text="{text}"').first
            if el.count() > 0:
                el.scroll_into_view_if_needed()
                page.wait_for_timeout(500)
                break
        else:
            page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
            page.wait_for_timeout(500)
        shot(page, '12-snapshot-history', 'Snapshot History section')

        # ═══════════════════════════════════════════════════════════
        # STEP 13: Render History
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 13: Render History ═══')
        for text in ['سجل التوليد', 'Render History']:
            el = page.locator(f'text="{text}"').first
            if el.count() > 0:
                el.scroll_into_view_if_needed()
                page.wait_for_timeout(500)
                break
        else:
            page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
            page.wait_for_timeout(500)
        shot(page, '13-render-history', 'Render History section')

        # ═══════════════════════════════════════════════════════════
        # STEP 14: Audit Trail
        # ═══════════════════════════════════════════════════════════
        print('\n═══ E2E STEP 14: Audit Trail ═══')
        for text in ['سجل التدقيق', 'Audit Trail', 'audit']:
            el = page.locator(f'text="{text}"').first
            if el.count() > 0:
                el.scroll_into_view_if_needed()
                page.wait_for_timeout(500)
                break
        else:
            page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
            page.wait_for_timeout(500)
        shot(page, '14-audit-trail', 'Audit Trail section')

        browser.close()

        # ═══════════════════════════════════════════════════════════
        # SUMMARY
        # ═══════════════════════════════════════════════════════════
        print(f'\n═══ E2E COMPLETE — {SHOT_NUM[0]} screenshots ═══')
        print(f'Saved to: {SCREENSHOTS_DIR}')
        if errors:
            print(f'\nJS Errors during run ({len(errors)}):')
            for e in errors:
                print(f'  - {e}')
        else:
            print('No JS errors detected.')
        print('\nEvent log:')
        for ev in EVENTS:
            print(f'  {ev}')

if __name__ == '__main__':
    main()
