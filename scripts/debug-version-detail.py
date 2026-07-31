"""Debug: dump all visible text on version detail page to find section headings."""
from playwright.sync_api import sync_playwright

def safe_wait(page, timeout=6000):
    try:
        page.wait_for_load_state('networkidle', timeout=timeout)
    except:
        pass
    page.wait_for_timeout(1500)

def main():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page(viewport={'width':1440,'height':900})
        page.goto('http://localhost:5173/login')
        safe_wait(page)
        page.fill('#username','admin')
        page.fill('#password','admin123')
        page.click('button[type="submit"]')
        page.wait_for_url('http://localhost:5173/')
        page.wait_for_timeout(3000)

        page.goto('http://localhost:5173/templates/versions/4')
        safe_wait(page)
        page.wait_for_timeout(3000)

        # Get all visible text, line by line
        all_text = page.evaluate('() => document.body.innerText')
        print('=== FULL PAGE TEXT ===')
        for i, line in enumerate(all_text.split('\n')):
            l = line.strip()
            if l:
                print(f'  {i:3d}: "{l[:120]}"')

        # Also look for h2, h3, h4 elements
        print('\n=== HEADINGS ===')
        for tag in ['h1','h2','h3','h4']:
            els = page.locator(tag).all()
            for i, el in enumerate(els):
                try:
                    vis = el.is_visible()
                    txt = el.text_content().strip()[:100]
                    if vis and txt:
                        print(f'  {tag}[{i}]: "{txt}"')
                except:
                    pass

        browser.close()

if __name__ == '__main__':
    main()
