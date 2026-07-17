"""Debug: dump the full text and HTML of application detail page."""
from playwright.sync_api import sync_playwright

def main():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={'width':1440,'height':900})

        # Capture console errors
        errors = []
        page.on('console', lambda msg: errors.append(f'{msg.type}: {msg.text}') if msg.type == 'error' else None)
        page.on('pageerror', lambda exc: errors.append(f'PAGE_ERROR: {exc.message}'))

        page.goto('http://localhost:5173/login')
        page.wait_for_load_state('networkidle')
        page.wait_for_timeout(1500)
        page.fill('#username','admin')
        page.fill('#password','admin123')
        page.click('button[type="submit"]')
        page.wait_for_url('http://localhost:5173/')
        page.wait_for_timeout(3000)

        page.goto('http://localhost:5173/applications/110')
        page.wait_for_load_state('networkidle')
        page.wait_for_timeout(5000)

        # Get all text
        all_text = page.evaluate('() => document.body.innerText')
        print('=== PAGE TEXT ===')
        print(all_text[:3000])

        print('\n=== CONSOLE ERRORS ===')
        for e in errors:
            print(e)

        # Check if DocumentGenerationSection exists in DOM at all
        dgs = page.locator('text=توليد مستند').count()
        print(f'\n"توليد مستند" count: {dgs}')
        dgs2 = page.locator('text=Generate Document').count()
        print(f'"Generate Document" count: {dgs2}')

        # Check for any element with FileText icon class
        ft = page.locator('svg.lucide-file-text').count()
        print(f'FileText icons: {ft}')

        browser.close()

if __name__ == '__main__':
    main()
