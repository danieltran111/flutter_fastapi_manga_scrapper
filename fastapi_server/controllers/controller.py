import json


async def get_all_mangas_info():
    manga_data, chapters_detail = await getData(
        "json/manga_data.json", "json/chapters_detail.json"
    )
    return manga_data

async def get_by_mangaid(manga_id: int):
    manga_data, chapters_detail = await getData(
        "json/manga_data.json", "json/chapters_detail.json"
    )
    for d in manga_data:
        print(type(d["id"]))
        if d["id"] == manga_id:
            return d, 200
    # print("ttthere")
    result = {"err"}
    return result, 500

async def get_by_chapter_id(
    manga_id: int, chapter_id: int
):
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
        return result, 500

    return chapter, 200

async def like_manga(manga_id):
    manga_data = get_manga_data()
    for d in manga_data:
        if d["id"] == manga_id:
            d["liked"] = True
            print(manga_data)
            await saveData(manga_data, "json/manga_data.json")
            return manga_data


async def get_manga_data():
    file = open("json/manga_data.json")
    manga_data = json.load(file)
    return manga_data

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

