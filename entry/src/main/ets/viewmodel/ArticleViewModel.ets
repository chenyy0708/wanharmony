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

export class ArticleBean {
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

class ArticleViewModel {

  getBannerList(): Promise<Banner[]> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url = `${Const.SERVER}/${Const.GET_BANNER_LIST}`;
      httpRequestGet(url).then((response: ResponseResult) => {
        if (response.errorCode === 0) {
          resolve(response.data || []);
        } else {
          Logger.error('getNewsList failed', JSON.stringify(response));
          reject($r('app.string.page_none_msg'));
        }
      }).catch((err: Error) => {
        Logger.error('getNewsList failed', JSON.stringify(err));
        reject($r('app.string.http_error_message'));
      });
    });
  }

  getArticleList(currentPage: number, pageSize: number, path: string): Promise<ArticleBean[]> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url = `${Const.SERVER}/${path}`;
      url += `/${currentPage}/json`;
      httpRequestGet(url).then((data: ResponseResult) => {
        if (data.errorCode === 0) {
          resolve(data.data?.datas || []);
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

  getArticleTopList(): Promise<ArticleBean[]> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url = `${Const.SERVER}/${Const.GET_TOP_ARTICLE_LIST}`;
      httpRequestGet(url).then((response: ResponseResult) => {
        if (response.errorCode === 0) {
          resolve(response.data || []);
        } else {
          Logger.error('getNewsList failed', JSON.stringify(response));
          reject($r('app.string.page_none_msg'));
        }
      }).catch((err: Error) => {
        Logger.error('getNewsList failed', JSON.stringify(err));
        reject($r('app.string.http_error_message'));
      });
    });
  }
}

let articleViewModel = new ArticleViewModel();

export default articleViewModel as ArticleViewModel;


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


export class ResponseResult {
  errorCode: number;
  errorMsg: string | Resource;
  data: any | undefined;

  constructor() {
    this.errorCode = 0;
    this.errorMsg = '';
  }
}

export class Banner {
  desc?: string;
  id?: number;
  imagePath?: string;
  isVisible?: number;
  order?: number;
  title?: string;
  type?: number;
  url?: string;
}
