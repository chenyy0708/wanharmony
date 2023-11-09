/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CommonConstant as Const } from '../common/constant/CommonConstant';
import { httpRequestGet } from '../common/utils/HttpUtil';
import Logger from '../common/utils/Logger';

export class  ArticleBean {
  adminAdd?: boolean;
  apkLink?: string;
  audit?: number;
  author?: string;
  canEdit?: boolean;
  chapterId?: number;
  chapterName?: string;
  collect?: boolean;
  courseId?: number;
  desc?: string;
  descMd?: string;
  envelopePic?: string;
  fresh?: boolean;
  host?: string;
  id?: number;
  isAdminAdd?: boolean;
  link?: string;
  niceDate?: string;
  niceShareDate?: string;
  origin?: string;
  prefix?: string;
  projectLink?: string;
  publishTime?: number;
  realSuperChapterId?: number;
  selfVisible?: number;
  shareDate?: number;
  shareUser?: string;
  superChapterId?: number;
  superChapterName?: string;
  tags?: any[];
  title?: string;
  type?: number;
  userId?: number;
  visible?: number;
  zan?: number;
}

class NewsViewModel {
  /**
   * Get news type list from server.
   *
   * @return NewsTypeBean[] newsTypeList
   */
  getNewsTypeList(): Promise<ArticleBean[]> {
    return new Promise((resolve: Function) => {
      let url = `${Const.SERVER}/${Const.GET_NEWS_TYPE}`;
      httpRequestGet(url).then((data: ResponseResult) => {
        if (data.errorCode === Const.SERVER_CODE_SUCCESS) {
          resolve(data.data);
        } else {
          resolve([]);
        }
      }).catch(() => {
        resolve([]);
      });
    });
  }

  /**
   * Get default news type list.
   *
   * @return NewsTypeBean[] newsTypeList
   */
  getDefaultTypeList(): NewsTypeBean[] {
    return Const.TabBars_DEFAULT_NEWS_TYPES;
  }

  /**
   * Get news type list from server.
   *
   * @return NewsData[] newsDataList
   */
  getNewsList(currentPage: number, pageSize: number, path: string): Promise<ArticleBean[]> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url = `${Const.SERVER}/${path}`;
      url += `/${currentPage}/json`;
      httpRequestGet(url).then((data: ResponseResult) => {
        if (data.errorCode === 0) {
          resolve(data.data.datas);
        } else {
          Logger.error('getNewsList failed', JSON.stringify(data));
          reject($r('app.string.page_none_msg'));
        }
      }).catch((err: Error) => {
        Logger.error('getNewsList failed', JSON.stringify(err));
        reject($r('app.string.http_error_message'));
      });
    });
  }
}

let newsViewModel = new NewsViewModel();

export default newsViewModel as NewsViewModel;

/**
 * News list item info.
 */
export class NewsData {
  /**
   * News list item title.
   */
  title: string = '';

  /**
   * News list item content.
   */
  content: string = '';

  /**
   * News list item imagesUrl.
   */
  imagesUrl: Array<NewsFile> = [new NewsFile()];

  /**
   * News list item source.
   */
  source: string = '';
}

/**
 * News image list item info.
 */
export class NewsFile {
  /**
   * News image list item id.
   */
  id: number = 0;

  /**
   * News image list item url.
   */
  url: string = '';

  /**
   * News image list item type.
   */
  type: number = 0;

  /**
   * News image list item newsId.
   */
  newsId: number = 0;
}

/**
 * Custom refresh load layout data.
 */
@Observed
export class CustomRefreshLoadLayoutClass {
  /**
   * Custom refresh load layout isVisible.
   */
  isVisible: boolean;

  /**
   * Custom refresh load layout imageSrc.
   */
  imageSrc: Resource;

  /**
   * Custom refresh load layout textValue.
   */
  textValue: Resource;

  /**
   * Custom refresh load layout heightValue.
   */
  heightValue: number;

  constructor(isVisible: boolean, imageSrc: Resource, textValue: Resource, heightValue: number) {
    this.isVisible = isVisible;
    this.imageSrc = imageSrc;
    this.textValue = textValue;
    this.heightValue = heightValue;
  }
}

export class NewsTypeBean {
  id: number = 0;
  name: ResourceStr = '';
}

export class ResponseResult {
  /**
   * Code returned by the network request: success, fail.
   */
  errorCode: number;

  /**
   * Message returned by the network request.
   */
  errorMsg: string | Resource;

  /**
   * Data returned by the network request.
   */
  data: ResponseData | undefined;

  constructor() {
    this.errorCode = 0;
    this.errorMsg = '';
  }
}

export class ResponseData {
  curPage?: number;
  datas?: string | Object | ArrayBuffer;
  offset?: number;
  over?: boolean;
  pageCount?: number;
  size?: number;
  total?: number;
}