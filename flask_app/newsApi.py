from re import M
from flask import Flask
import requests
from bs4 import BeautifulSoup
from flask_caching import Cache

config = {
    "DEBUG": True,
    "CACHE_TYPE": "SimpleCache",
    "CACHE_DEFAULT_TIMEOUT": 300
}
app = Flask(__name__)
app.config.from_mapping(config)
cache = Cache(app)


cache.init_app(app)

tuoi_tre_type = {
    'new': 'tin-moi-nhat.htm',
    'global': 'the-gioi.htm',
    'business': 'kinh-doanh.htm',
    'entertaiment': 'giai-tri.htm',
    'law': 'phap-luat.htm',
    'health': 'suc-khoe.htm',
    'edu': 'giao-duc.htm',
}
vnexpress_type = {
    'new': 'tin-tuc-24h',
    'global': 'the-gioi',
    'business': 'kinh-doanh',
    'entertaiment': 'giai-tri',
    'law': 'phap-luat',
    'health': 'suc-khoe',
    'edu': 'giao-duc',
}
zn_type = {
    'new': '',
    'global': 'the-gioi.html',
    'business': 'kinh-doanh-tai-chinh.html',
    'entertaiment': 'giai-tri.html',
    'law': 'phap-luat.html',
    'health': 'suc-khoe.html',
    'edu': 'giao-duc.html',
}


@app.route("/get-all-news/<type>")
@cache.cached(timeout=7200)
def get_all_news_by_type(type):
    news = []
    news.extend(get_tuoi_tre_by_type(type))
    news.extend(get_vnexpress_by_type(type))
    news.extend(get_zing_by_type(type))
    tmp = sorted(news, key=lambda i: i['title'])
    return {
        'news': tmp
    }


@app.route("/get-new-by-url/<source>/<url>")
def get_new_by_url(source, url):
    if (source == 'ttr'):
        return get_ttre_by_url(url)
    if (source == 'vne'):
        return get_vnexpress_by_url(url)
    if (source == 'zn'):
        return get_zing_by_url(url)


@app.route("/get-tuoi-tre/<type>")
@cache.cached(timeout=7200)
def get_tuoi_tre(type):
    news = []
    news.extend(get_tuoi_tre_by_type(type))
    return {
        'news': news
    }


def get_tuoi_tre_by_type(type):
    lsNews = []
    response = requests.get("https://tuoitre.vn/" +
                            tuoi_tre_type.get(type))
    soup = BeautifulSoup(response.content, features="lxml")

    titles = soup.find_all('h3', class_='title-news')
    links = [link.find('a').attrs["href"] for link in titles]

    for link in links:
        id = str(hash(link))
        news = requests.get("https://tuoitre.vn" + link)
        soup = BeautifulSoup(news.content, features="lxml")
        title = soup.find('h1', class_='article-title')
        body = soup.find("div", id="main-detail-body")
        try:
            image = body.find("img").attrs["src"]
        except:
            print('something went wrong')
        try:
            new = {
                "source": "ttr",
                "title": title.text,
                "url": link[1:],
                "urlToImage": image,
                "id": id,
            }
            lsNews.append(new)
        except:
            print("Something went wrong")
    return lsNews


@app.route("/get-tuoi-tre-url/<url>")
def get_ttre_by_url(url):
    response = requests.get("https://tuoitre.vn/" + url)
    soup = BeautifulSoup(response.content, features="lxml")
    author = soup.find('div', class_='author')
    title = soup.find('h1', class_='article-title')
    abstract = soup.find("h2", class_="sapo")
    publishedAt = soup.find('div', class_='date-time')
    body = soup.find("div", id="main-detail-body")
    try:
        contents = body.findChildren("p", recursive=False)
        content = ""
        for c in contents:
            content = content + c.text + " "
            image = body.find("img").attrs["src"]
    except:
        print("Something else went wrong")
    return {
        "source": "Tuổi trẻ",
        "author": author.text,
        "title": title.text,
        "description": abstract.text,
        "url": "https://tuoitre.vn/" + url,
        "urlToImage": image,
        "publishedAt": publishedAt.text,
        "content": content,
    }


@app.route("/get-vnexpress/<type>")
@cache.cached(timeout=7200)
def get_vnexpress(type):
    news = []
    news.extend(get_vnexpress_by_type(type))
    return {
        'news': news
    }


def get_vnexpress_by_type(type):
    lsNews = []
    response = requests.get("https://vnexpress.net/" +
                            vnexpress_type.get(type))
    soup = BeautifulSoup(response.content, features="lxml")

    titles = soup.find_all('h3', class_='title-news')
    links = [link.find('a').attrs["href"] for link in titles]
    for link in links:
        id = str(hash(link))
        news = requests.get(link)
        soup = BeautifulSoup(news.content, features="lxml")
        title = soup.find('h1', class_='title-detail')
        try:
            picture = soup.find('picture').find('img')
            image = picture['data-src']
        except:
            print('something went wrong')
        try:
            new = {
                "source": "vne",
                "title": title.text,
                "url": link[22:],
                "urlToImage": image,
                "id": id,
            }
            lsNews.append(new)
        except:
            print("Something went wrong")
    return lsNews


@app.route("/get-vnexpress-url/<url>")
def get_vnexpress_by_url(url):
    response = requests.get("https://vnexpress.net/" + url)
    soup = BeautifulSoup(response.content, features="lxml")
    title = soup.find('h1', class_='title-detail')
    abstract = soup.find("p", class_="description")
    publishedAt = soup.find('span', class_='date')
    body = soup.find_all("p", class_="Normal")
    try:
        picture = soup.find('picture').find('img')
        image = picture['data-src']
        content = ""
        for i in range(len(body)-1):
            content = content + body[i].text + " "
        author = body[len(body)-1].text
    except:
        print("Something else went wrong")
    return {
        "source": "VNExpress",
        "author": author,
        "title": title.text,
        "description": abstract.text,
        "url": url,
        "urlToImage": image,
        "publishedAt": publishedAt.text,
        "content": content,
    }


@app.route("/get-zing/<type>")
@cache.cached(timeout=7200)
def get_zing(type):
    news = []
    news.extend(get_zing_by_type(type))
    return {
        'news': news
    }


def get_zing_by_type(type):
    lsNews = []
    response = requests.get("https://zingnews.vn/" +
                            zn_type.get(type))
    soup = BeautifulSoup(response.content, features="lxml")

    titles = soup.find_all('p', class_='article-title')
    links = [link.find('a').attrs["href"] for link in titles]
    for link in links:
        id = str(hash(link))
        news = requests.get('https://zingnews.vn' + link)
        soup = BeautifulSoup(news.content, features="lxml")
        title = soup.find('h1', class_='the-article-title')
        try:
            pic = soup.find('div', class_='the-article-body').find('img')
            image = pic['data-src']
        except:
            print('something went wrong')
        try:
            new = {
                "source": "zn",
                "title": title.text,
                "url": link[1:],
                "urlToImage": image,
                "id": id,
            }
            lsNews.append(new)
        except:
            print("Something went wrong")
    return lsNews


@app.route("/get-zing-url/<url>")
def get_zing_by_url(url):
    response = requests.get("https://zingnews.vn/" + url)
    soup = BeautifulSoup(response.content, features="lxml")
    title = soup.find('h1', class_='the-article-title')
    abstract = soup.find("p", class_="the-article-summary")
    publishedAt = soup.find('li', class_='the-article-publish')
    author = soup.find('p', class_='author')
    body = soup.find("div", class_="the-article-body")
    try:
        pic = soup.find('div', class_='the-article-body').find('img')
        image = pic['data-src']
        content = ""
        for b in body.find_all('p'):
            if b.has_attr('class'):
                break
            content = content + b.text + " "
    except:
        print("Something else went wrong")
    return {
        "source": "Zing News",
        "author": author.text,
        "title": title.text,
        "description": abstract.text,
        "url": url,
        "urlToImage": image,
        "publishedAt": publishedAt.text,
        "content": content,
    }


if __name__ == "__main__":
    app.run()
