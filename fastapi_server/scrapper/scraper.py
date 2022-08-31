import asyncio
from operator import getitem
from unittest import result
from urllib import response
from cv2 import add
from matplotlib import image
import requests
import os
from bs4 import BeautifulSoup
import json
import cloudscraper
from urllib.request import Request, urlopen
from pathlib import Path

import constants

# import scrapper.constants as constants


def getChapterImages(address, chapterId):
    header = {"User-Agent": "Mozilla/5.0", "referer": "http://nhattruyenone.com/"}
    req = Request(address, headers=header)
    page = urlopen(req)
    soup = BeautifulSoup(page, "html.parser")
    image_list = (
        soup.find("main", {"class": "main"})
        .find("div", {"class": "reading-detail box_doc"})
        .findAll("div", {"class": "page-chapter"})
    )
    images = []
    path = "resource/images/" + str(chapterId)

    if os.path.exists(path):
        # print("already")
        for image in image_list:
            id = chapterId
            src = image.find("img").attrs["src"]

            static_path = constants.IMAGE_URL + str(chapterId) + "/" + image.attrs["id"]

            images.append(static_path)
        return images

    os.makedirs(path)

    for image in image_list:
        id = chapterId
        src = image.find("img").attrs["src"]

        folder = "resource/images/" + str(chapterId) + "/" + image.attrs["id"]
        static_path = (
            constants.IMAGE_URL + str(chapterId) + "/" + image.attrs["id"] + ".jpg"
        )
        images.append(static_path)

        # download:
        if "http" in src:
            downloadImage(folder, src)
        else:
            downloadImage(folder, "http:" + src)
    # print(images)
    return images


def downloadImage(saveAddress, url):
    if os.path.exists(saveAddress + ".jpg"):
        return
    with open(saveAddress + ".jpg", "wb+") as handle:
        try:
            response = requests.get(
                url, headers={"referer": "http://nhattruyenone.com/"}
            )
            if not response.ok:
                print("Warning response!")
                print(response)
                # writelog(response)

            for block in response.iter_content(1024):
                if not block:
                    break
                handle.write(block)
            handle.close()
        except Exception as e:
            print("Exception: ", e)
            handle.close()


def getMangaChapters(address, mode_downloading):
    header = {"User-Agent": "Mozilla/5.0", "referer": "http://nhattruyenone.com/"}
    req = Request(address, headers=header)
    # response = requests.get(address, headers = header)
    # print(response.headers)
    page = urlopen(req)
    soup = BeautifulSoup(page, "html.parser")
    chapter_list = (
        soup.find("main", {"class": "main"})
        .find("div", {"class": "list-chapter"})
        .findAll("li")[0:]
    )
    tags = (
        soup.find("li", {"class": "kind row"})
        .find("p", {"class": "col-xs-8"})
        .findAll("a")
    )
    tags_result = []
    for t in tags:
        tags_result.append(t.text)
    chapter_links = []
    chapters_no_links = []
    for chapter in chapter_list:
        link = chapter.find("a").attrs["href"]
        cid = chapter.find("a").attrs["data-id"]
        cid = int(cid)

        if mode_downloading == True:
            chapter_links.append(
                {
                    "id": cid,
                    "name": chapter.find("a").text.strip(),
                    "images": getChapterImages(link, cid),
                }
            )

        chapters_no_links.append({"id": cid, "name": chapter.find("a").text.strip()})

    # return chapters_no_links, chapter_links, tags_result
    return chapters_no_links, chapter_links, tags_result


# def get_liked_mangas_chapters(index):
#     address_sub = "http://www.nhattruyenone.com/tim-truyen?page={page_index}"
#     if index == 1:
#         address = "http://www.nhattruyenone.com/tim-truyen"
#     else:
#         address = address_sub.format(page_index=index)

#     items = []

#     header = {"User-Agent": "Mozilla/5.0", "referer": "http://nhattruyenone.com/"}
#     req = Request(address, headers=header)

#     page = urlopen(req)
#     soup = BeautifulSoup(page, "html.parser")
#     items_content = soup.find("div", {"class": "items"}).findAll(
#         "div", {"class": "item"}
#     )
#     chapters_detail_result = []
#     i = 0
#     for item in items_content:
#         i += 1
#         if i == 2:
#             break
#         # TODO: check if manga exist by manga id, if yes, modify its info, take care of chapters
#         # if not -> do fresh download
#         manga_id = item.find("ul", {"class": "comic-item"}).attrs["data-id"]
#         manga_id = int(manga_id)
#         # print(type(manga_id))
#         imageLink = (
#             item.find("div", {"class": "image"}).find("img").attrs["data-original"]
#         )
#         folder = "resource/mangaCoverImages/" + str(manga_id)
#         downloadImage(folder, "http:" + imageLink)
#         manga_src = item.find("div", {"class": "image"}).find("a").attrs["href"]
#         static_path = constants.COVER_URL + str(manga_id) + ".jpg"
#         item_info = {
#             "id": manga_id,
#             "image": static_path,
#             "fullname": item.find("div", {"class": "title"}).text.strip(),
#             "tags": [],
#             "description": item.find("div", {"class": "box_text"}).text.strip(),
#         }

#         # download description and detail, list chapter link
#         item_info["chapters"], chapters_detail, item_info["tags"] = getMangaChapters(
#             manga_src
#         )

#         items.append(item_info)
#         chapters_detail_result = chapters_detail_result + chapters_detail

#     # return items, chapters_detail_result
#     with open("json/manga_data.json", "w") as outfile:
#         json.dump(items, outfile)
#     with open("json/chapters_detail.json", "w") as outfile:
#         json.dump(chapters_detail_result, outfile)


# # params: path manga_data, path chapters_detail
# def generateData():
#     get_liked_mangas_chapters(2)


async def get_mangas_info_by_page(index):

    address_sub = "http://www.nhattruyenone.com/tim-truyen?page={page_index}"
    if index == 1:
        address = "http://www.nhattruyenone.com/tim-truyen"
    else:
        address = address_sub.format(page_index=index)

    items = []

    header = {"User-Agent": "Mozilla/5.0", "referer": "http://nhattruyenone.com/"}
    req = Request(address, headers=header)

    page = urlopen(req)
    soup = BeautifulSoup(page, "html.parser")
    items_content = soup.find("div", {"class": "items"}).findAll(
        "div", {"class": "item"}
    )
    i = 0
    for item in items_content:
        i += 1
        if i == 2:
            break
        # TODO: check if manga exist by manga id, if yes, modify its info, take care of chapters
        # if not -> do fresh download
        manga_id = item.find("ul", {"class": "comic-item"}).attrs["data-id"]
        manga_id = int(manga_id)

        imageLink = (
            item.find("div", {"class": "image"}).find("img").attrs["data-original"]
        )
        folder = "resource/mangaCoverImages/" + str(manga_id)
        downloadImage(folder, "http:" + imageLink)
        manga_src = item.find("div", {"class": "image"}).find("a").attrs["href"]
        static_path = constants.COVER_URL + str(manga_id) + ".jpg"
        item_info = {
            "id": manga_id,
            "image": static_path,
            "fullname": item.find("div", {"class": "title"}).text.strip(),
            "tags": [],
            "liked": False,
            "href": manga_src,
            "description": item.find("div", {"class": "box_text"}).text.strip(),
        }
        chapters, chapters_detail, item_info["tags"] = getMangaChapters(
            manga_src, False
        )
        item_info["no_of_chapters"] = len(chapters)
        items.append(item_info)

    # return items, chapters_detail_result
    # with open("json/manga_data.json", "w") as outfile:
    #     json.dump(items, outfile)

    return items


async def add_mangas_data(new_mangas_data):
    data = await get_all_mangas_info()
    id_list = []
    for d in data:
        id_list.append(d["id"])
    print(id_list)
    for m in new_mangas_data:
        if m["id"] in id_list:
            print("skip")
            continue
        data.append(m)
    await saveData(data, "json/manga_data.json")
    return
    # chapters, m["tags"] = getMangaChapters(m["href"])
    # m["no_of_chapters"] = len(chapters)


async def add_chapters_data(new_chapters_data):
    data = await get_chapters_info()
    id_list = []
    for d in data:
        id_list.append(d["id"])
    print(id_list)
    for m in new_chapters_data:
        if m["id"] in id_list:
            print("skip")
            continue
        data.append(m)
    await saveData(data, "json/chapters_detail.json")
    return


async def get_all_mangas_info():
    file = open("json/manga_data.json")
    dataJSON = json.load(file)
    file.close()

    return dataJSON


async def get_chapters_info():
    file = open("json/chapters_detail.json")
    dataJSON = json.load(file)
    file.close()

    return dataJSON


async def saveData(data, path):
    file = open(path, "r")
    dataJSON = json.load(file)
    file.close()

    dataJSON = data
    file = open(path, "w+")
    file.write(json.dumps(dataJSON))
    file.close()

    return


async def get_liked_mangas():
    data = await get_all_mangas_info()
    chapter_data = await get_chapters_info()
    for manga in data:
        if manga["liked"] == True:
            print("here")
            manga["chapters"], chapters_detail, tags = getMangaChapters(
                manga["href"], True
            )
            chapter_data = chapter_data + chapters_detail
    await saveData(data, "json/manga_data.json")

    await saveData(chapter_data, "json/chapters_detail.json")


async def tri():
    d = await get_mangas_info_by_page(2)
    await add_mangas_data(d)
    await get_liked_mangas()


print(asyncio.run(tri()))


# print(get_all_mangas_info())W
