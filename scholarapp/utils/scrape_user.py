from abc import ABC, abstractmethod
from enum import Enum
from typing import Any
from urllib.parse import quote_plus
from parsel import Selector
from playwright.sync_api import sync_playwright
from scholarly import scholarly


def get_tag_text(tag: Selector):
    return tag.xpath("normalize-space()")[0].get()


HEADLESS = True


class ImportBackend(Enum):
    RESEARCHGATE = "researchgate"
    GOOGLESCHOLAR = "googlescholar"


class ProfileScraper(ABC):

    @abstractmethod
    def scrape_user(self, name: str) -> list[dict[str, Any]]:
        pass

    @abstractmethod
    def scrape_publications(self, link_or_name: str) -> list[dict[str, Any]]:
        pass


class ResearchGateScraper(ProfileScraper):
    def scrape_user(self, name: str) -> list[dict[str, Any]]:
        with sync_playwright() as p:
            browser = p.firefox.launch(headless=HEADLESS, timeout=0)
            browser.new_context().set_default_timeout(0)
            context = browser.new_context(
                user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36"
            )

            authors = []
            page = context.new_page()

            page.goto(
                f"https://www.researchgate.net/search/researcher?q={quote_plus(name+ ' Beirut Arab University')}&page=1",
                timeout=0,
            )
            selector = Selector(text=page.content())

            for author in selector.css(".nova-legacy-c-card__body--spacing-inherit"):
                author_dict = {}
                thumbnail = (
                    author.css(".nova-legacy-e-avatar__img")[0].xpath("@src").get()
                )
                sections = author.css(".nova-legacy-v-entity-item__stack-item")
                name = get_tag_text(sections[0].css(".nova-legacy-e-text")[0])
                profile_page = "https://www.researchgate.net/" + (
                    author.css(".nova-legacy-c-button").xpath("@href")[0].get()
                )
                author_dict.update(
                    {"avatar": thumbnail, "profile_page": profile_page, "name": name}
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
                    lambda author: (author.get("Institution"))
                    == "Beirut Arab University",
                    authors,
                )
            )

    def scrape_publications(self, link_or_name: str) -> list[dict[str, Any]]:
        with sync_playwright() as p:
            browser = p.firefox.launch(headless=HEADLESS, timeout=0)
            context = browser.new_context(
                user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36"
            )
            context.set_default_timeout(0)
            page = context.new_page()
            page.goto(link_or_name, timeout=None)
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
                if not publication.css('span[class=""]'):
                    continue  # we only want publications that have a date.
                date_created = publication.css('span[class=""]')[0]
                publication_link = publication.css(
                    ".nova-legacy-v-publication-item__title > a"
                )
                research_type = publication.css(
                    ".nova-legacy-e-badge--luminosity-high"
                )[0]
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


class GoogleScholarScraper(ProfileScraper):

    def parse_citation(self, citation: str) -> str:
        citation = citation.lower().strip()
        if citation.find("journal"):
            event_type = "Journal Paper"
        elif citation.find("citation"):
            event_type = "Conference Paper"
        else:
            event_type = "Article"
        return event_type

    def get_author_info(
        self, author_name: str, sections: tuple[str, ...]
    ) -> dict[str, Any]:
        author = next(scholarly.search_author(author_name), None)  # type: ignore
        if author:
            filled = scholarly.fill(
                author,
                sortby="year",
                sections=list(sections),
                publication_limit=10,
            )
            if isinstance(filled, bool):
                return {}

            return {
                "name": filled["name"],
                "avatar": filled["url_picture"],
                "publications": filled.get("publications", []),
            }
        return {}

    def scrape_user(self, name: str) -> list[dict[str, Any]]:
        return [self.get_author_info(name, ("basic_info",))]

    def scrape_publications(self, link_or_name: str) -> list[dict[str, Any]]:
        unprocessed_publications = self.get_author_info(
            link_or_name, ("basic_info", "publications")
        )["publications"]

        processed_publications = []

        for publication in unprocessed_publications:
            bib = publication["bib"]
            title = bib["title"]
            date_created = bib["pub_year"]
            event_type = self.parse_citation(bib["citation"])
            processed_publications.append(
                {
                    "title": title,
                    "description": "",
                    "date_created": date_created,
                    "research_type": event_type,
                }
            )

        return processed_publications


def get_scraper(backend: str) -> ProfileScraper:
    if backend == ImportBackend.GOOGLESCHOLAR.value:
        return GoogleScholarScraper()
    return ResearchGateScraper()
