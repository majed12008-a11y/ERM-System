"""Inspect the application detail page to find DocumentGenerationSection buttons."""
from playwright.sync_api import sync_playwright

def main():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={'width':1440,'height':900})
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
        page.wait_for_timeout(3000)

        # Scroll to bottom to find the document generation section
        page.evaluate('window.scrollTo(0, document.body.scrollHeight)')
        page.wait_for_timeout(1000)

        # Get all buttons text
        buttons = page.locator('button').all()
        print(f'Total buttons: {len(buttons)}')
        for i, btn in enumerate(buttons):
            try:
                vis = btn.is_visible()
                txt = btn.text_content().strip()[:80]
                if vis and txt:
                    print(f'  btn[{i}]: vis={vis} text="{txt}"')
            except:
                pass

        # Also look for any section with text containing generate/tolid
        all_text = page.evaluate('() => document.body.innerText')
        for line in all_text.split('\n'):
            l = line.strip()
            if any(w in l for w in ['توليد','Generate','معاينة','Preview','document','Document']):
                if len(l) > 0:
                    print(f'  TEXT: "{l[:120]}"')

        # Check for SVG icons (Eye, FileDown) in the document generation section
        eye_icons = page.locator('svg.lucide-eye').all()
        print(f'\nEye icons (Preview): {len(eye_icons)}')
        filedwn = page.locator('svg.lucide-file-down').all()
        print(f'FileDown icons (Generate): {len(filedwn)}')

        # Check h3 with FileText icon (document generation section header)
        h3s = page.locator('h3').all()
        for i, h3 in enumerate(h3s):
            try:
                vis = h3.is_visible()
                txt = h3.text_content().strip()[:80]
                if vis:
                    print(f'  h3[{i}]: "{txt}"')
            except:
                pass

        browser.close()

if __name__ == '__main__':
    main()
