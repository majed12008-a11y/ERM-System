"""
Inspect the login page DOM to discover correct selectors.
"""
from playwright.sync_api import sync_playwright

BASE = 'http://localhost:5173'

def main():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={'width': 1440, 'height': 900})

        print("[1] Navigating to login page...")
        page.goto(f'{BASE}/login')
        page.wait_for_load_state('networkidle')
        page.wait_for_timeout(2000)

        # Screenshot the login page
        page.screenshot(path='C:/ERM-System/docs/screenshots/rc2/00-login-page.png', full_page=True)
        print("  Screenshot saved.")

        # Dump all form elements
        print("\n[2] Form elements:")
        inputs = page.locator('input').all()
        for i, inp in enumerate(inputs):
            attrs = page.evaluate('''(el) => {
                const attrs = {};
                for (const a of el.attributes) attrs[a.name] = a.value;
                return attrs;
            }''', inp.element_handle())
            print(f"  input[{i}]: {attrs}")

        buttons = page.locator('button').all()
        for i, btn in enumerate(buttons):
            text = btn.text_content()
            attrs = page.evaluate('''(el) => {
                const attrs = {};
                for (const a of el.attributes) attrs[a.name] = a.value;
                return attrs;
            }''', btn.element_handle())
            print(f"  button[{i}]: text='{text.strip()}' attrs={attrs}")

        # Also check labels
        labels = page.locator('label').all()
        for i, lbl in enumerate(labels):
            print(f"  label[{i}]: '{lbl.text_content().strip()}' for='{lbl.get_attribute('for')}'")

        # Check for select elements
        selects = page.locator('select').all()
        for i, sel in enumerate(selects):
            attrs = page.evaluate('''(el) => {
                const attrs = {};
                for (const a of el.attributes) attrs[a.name] = a.value;
                return attrs;
            }''', sel.element_handle())
            print(f"  select[{i}]: {attrs}")

        # Dump the page HTML form area
        print("\n[3] Page HTML (form area):")
        form_html = page.evaluate('''() => {
            const form = document.querySelector('form') || document.querySelector('[class*="login"]') || document.querySelector('[class*="Login"]');
            return form ? form.outerHTML.substring(0, 3000) : 'NO FORM FOUND';
        }''')
        print(form_html)

        # Also try getting any role-based elements
        print("\n[4] ARIA / Role elements:")
        role_elements = page.locator('[role]').all()
        for i, el in enumerate(role_elements):
            role = el.get_attribute('role')
            text = el.text_content().strip()[:80]
            print(f"  [{role}]: '{text}'")

        browser.close()
        print("\nDone.")

if __name__ == '__main__':
    main()
