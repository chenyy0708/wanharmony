import { CommonConstant as Const } from '../common/constant/CommonConstant';
import { fetch } from '../common/utils/FetchUtil';
import Logger from '../common/utils/Logger';
import { ArticleBean, ResponseResult } from './ArticleViewModel';

export interface KnowledgeBean {
  articleList?: any[];
  author?: string;
  children?: KnowledgeBean[];
  courseId?: number;
  cover?: string;
  desc?: string;
  id?: number;
  lisense?: string;
  lisenseLink?: string;
  name?: string;
  order?: number;
  parentChapterId?: number;
  type?: number;
  userControlSetTop?: boolean;
  visible?: number;
}


class KnowledgeViewMode {
  getKnowledgeList(): Promise<KnowledgeBean[]> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url = `${Const.SERVER}/tree/json`;
      fetch({ url }).then((response: ResponseResult) => {
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

  getKnowledgeDetail(courseId: number): Promise<ArticleBean[]> {
    return new Promise(async (resolve: Function, reject: Function) => {
      let url = `${Const.SERVER}/article/list/0/json?cid=${courseId}`;
      fetch({ url }).then((response: ResponseResult) => {
        if (response.errorCode === 0) {
          resolve(response.data?.datas || []);
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

let knowledgeViewModel = new KnowledgeViewMode();

export default knowledgeViewModel as KnowledgeViewMode;

