from urllib.parse import quote_plus
from parsel import Selector
from playwright.sync_api import sync_playwright
from scholarly import scholarly


def get_tag_text(tag: Selector):
    return tag.xpath("normalize-space()")[0].get()


HEADLESS = True


def scrape_author(query: str) -> list[dict[str, list[str] | str]]:
    with sync_playwright() as p:
        browser = p.firefox.launch(headless=HEADLESS, timeout=0)
        browser.new_context().set_default_timeout(0)
        context = browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36"
        )

        authors = []
        page = context.new_page()

        page.goto(
            f"https://www.researchgate.net/search/researcher?q={quote_plus(query + ' Beirut Arab University')}&page=1",
            timeout=0,
        )
        selector = Selector(text=page.content())

        for author in selector.css(".nova-legacy-c-card__body--spacing-inherit"):
            author_dict = {}
            thumbnail = author.css(".nova-legacy-e-avatar__img")[0].xpath("@src").get()
            sections = author.css(".nova-legacy-v-entity-item__stack-item")
            name = get_tag_text(sections[0].css(".nova-legacy-e-text")[0])
            profile_page = "https://www.researchgate.net/" + (
                author.css(".nova-legacy-c-button").xpath("@href")[0].get()
            )
            author_dict.update(
                {"thumbnail": thumbnail, "profile_page": profile_page, "name": name}
            )
            for section in sections[1:]:
                attribute = get_tag_text(section.css(".nova-legacy-e-text")[0])
                values = [get_tag_text(tag) for tag in section.css("span")]
                if len(values) == 1:
                    values = values[0]
                author_dict[attribute] = values
            authors.append(author_dict)
        return list(
            filter(
                lambda author: (author.get("Institution")) == "Beirut Arab University",
                authors,
            )
        )


def scrape_publications(link: str):
    with sync_playwright() as p:
        browser = p.firefox.launch(headless=HEADLESS, timeout=0)
        context = browser.new_context(
            user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36"
        )
        context.set_default_timeout(0)
        page = context.new_page()
        page.goto(link, timeout=None)
        selector = Selector(text=page.content())
        publications = selector.css(".nova-legacy-v-publication-item")
        publication_list = []
        for publication in publications:
            description = None
            if len(info := publication.css(".nova-legacy-e-text")) > 1:
                title, description = info
            else:
                (title,) = info
            authors = publication.css(
                ".nova-legacy-v-publication-item__person-list span[itemprop='name']"
            )
            date_created = publication.css('span[class=""]')[0]
            publication_link = publication.css(
                ".nova-legacy-v-publication-item__title > a"
            )
            research_type = publication.css(".nova-legacy-e-badge--luminosity-high")[0]
            publication_list.append(
                {
                    "title": get_tag_text(title),
                    "description": get_tag_text(description) if description else "",
                    "authors": ",".join([get_tag_text(text) for text in authors]),
                    "date_created": get_tag_text(date_created),
                    "research_type": get_tag_text(research_type),
                    "link": publication_link,
                }
            )
        return publication_list


def get_author_json_scholar(author_name: str):
    author = next(scholarly.search_author(author_name))  # type: ignore
    if author:
        filled = scholarly.fill(
            author, sortby="year", sections=["publications"], publication_limit=10
        )
        print(type(filled))
        if isinstance(filled, bool):
            return
        return {
            "name": filled["name"],
            "profile_url": filled["url_picture"],
            "publications": filled["publications"],
        }
