from re import I
from fastapi import FastAPI, status, Response
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from typing import Optional, List
import json
from scrapper.scraper import *
from controllers.controller import *

# generateData()
app = FastAPI()

app.mount("/resource", StaticFiles(directory="resource"), name="resource")
# await

# print(manga_data)
# print(chapters_detail)


class Chapter(BaseModel):
    id: int
    name: str


class Manga(BaseModel):
    id: int
    image: str
    fullname: str
    tags: List[str] = []
    description: Optional[str] = None
    chapters: List[Chapter] = []


class ChapterDetail(BaseModel):
    id: int
    name: str
    images: List[str] = []


@app.get("/", response_model=List[Manga])
async def root():
    return await get_all_mangas_info()


@app.get("/mangas/", response_model=List[Manga])
async def read_items():
    return await get_all_mangas_info()


@app.get("/mangas/{manga_id}")
async def get_by_id(manga_id: int, response: Response) -> Manga:
    res, code = await get_by_mangaid(manga_id)
    if code == 200:
        return res
    # print("ttthere")
    result = {"err"}
    response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
    return result


@app.post("/mangas/like/{manga_id}")
async def like_by_id(manga_id: int, response: Response):
    manga_data, chapters_detail = await getData(
        "json/manga_data.json", "json/chapters_detail.json"
    )
    for d in manga_data:
        if d["id"] == manga_id:
            d["liked"] = True
            print(manga_data)
            await saveData(manga_data, "json/manga_data.json")
            return manga_data
    result = {"err"}
    response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
    return result


@app.post("/mangas/unlike/{manga_id}")
async def unlike_by_id(manga_id: int, response: Response):
    manga_data, chapters_detail = await getData(
        "json/manga_data.json", "json/chapters_detail.json"
    )
    for d in manga_data:
        if d["id"] == manga_id:
            d["liked"] = False
            print(manga_data)
            await saveData(manga_data, "json/manga_data.json")
            return manga_data
    result = {"err"}
    response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
    return result


@app.get("/mangas/{manga_id}/{chapter_id}")
async def get_by_chapter_id(
    manga_id: int, chapter_id: int, response: Response
) -> ChapterDetail:
    manga_data, chapters_detail = await getData(
        "json/manga_data.json", "json/chapters_detail.json"
    )
    result = {}
    found_manga = False
    found_chapter = False
    manga = {}
    chapter = {}
    for d in manga_data:
        if d["id"] == manga_id:
            for c in d["chapters"]:
                if c["id"] == chapter_id:
                    manga = c
                    found_manga = True
    for c in chapters_detail:
        if c["id"] == chapter_id:
            chapter = c
            found_chapter = True

    # result = {key: value for (key, value) in (manga.items() + chapter.items())}
    if not found_manga or not found_chapter:
        result = {"err"}
        response.status_code = status.HTTP_500_INTERNAL_SERVER_ERROR
        return result

    return chapter


async def getData(pathManga, pathChapters):
    file = open(pathManga)
    manga_data = json.load(file)
    file = open(pathChapters)
    chapters_detail = json.load(file)
    return manga_data, chapters_detail


async def saveData(data, path):
    file = open(path, "r")
    dataJSON = json.load(file)
    file.close()

    dataJSON = data
    file = open(path, "w+")
    file.write(json.dumps(dataJSON))
    file.close()


# todo: api get manga by id, get chapter by id
