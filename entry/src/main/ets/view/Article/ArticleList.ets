/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import promptAction from '@ohos.promptAction';
import { CommonConstant as Const, PageState } from '../../common/constant/CommonConstant';
import CustomRefreshLoadLayout from '../CustomRefreshLoadLayout';
import NewsViewModel, { ArticleBean, CustomRefreshLoadLayoutClass } from '../../viewmodel/ArticleViewModel';
import ArticleModel from '../../viewmodel/ArticleModel';
import { PullToRefresh, PullToRefreshConfigurator } from '@ohos/pulltorefresh';
import ArticleItem from './ArticleItem';
import BannerItem from './BannerItem';
import ArticleTopItem from './ArticleTopItem';

/**
 * The news list component.
 */
@Component
export default struct ArticleList {
  @State articleModel: ArticleModel = new ArticleModel();
  @Link currentIndex: number;
  @State data: ArticleBean[] = [];

  loadArticleData(isLoadMore: boolean) {
    if (isLoadMore) {
      this.articleModel.currentPage++;
    } else {
      this.articleModel.currentPage = 1;
    }
    this.articleModel.pageState = PageState.Success;
    this.articleModel.currentPage
    NewsViewModel.getArticleList(this.articleModel.currentPage, Const.GET_ARTICLE_LIST)
      .then((datas: ArticleBean[]) => {
        this.articleModel.pageState = PageState.Success;
        if (isLoadMore) {
          this.data = this.data.concat(datas);
        } else {
          this.data = datas;
        }
        this.articleModel.isRefreshing = false;
        this.articleModel.isCanLoadMore = true;
      })
      .catch((err: string | Resource) => {
        promptAction.showToast({
          message: err,
          duration: Const.ANIMATION_DURATION
        });
        this.articleModel.isRefreshing = false;
        this.articleModel.isCanLoadMore = true;
        this.articleModel.pageState = PageState.Fail;
      });
  }

  aboutToAppear() {
    this.loadArticleData(false);
  }

  build() {
    Column() {
      if (this.articleModel.pageState === PageState.Success) {
        this.ListLayout()
      } else if (this.articleModel.pageState === PageState.Loading) {
        this.LoadingLayout()
      } else {
        this.FailLayout()
      }
    }
    .width(Const.FULL_WIDTH)
    .height(Const.FULL_HEIGHT)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  LoadingLayout() {
    CustomRefreshLoadLayout({ customRefreshLoadClass: new CustomRefreshLoadLayoutClass(true,
      $r('app.media.ic_pull_up_load'), $r('app.string.pull_up_load_text'), this.articleModel.pullDownRefreshHeight) })
  }

  // 需绑定列表或宫格组件
  private scroller: Scroller = new Scroller();

  @Builder
  ListLayout() {
    PullToRefresh({
      data: $data,
      refreshConfigurator: new PullToRefreshConfigurator().setHasRefresh(true).setHasLoadMore(true),
      scroller: this.scroller,
      customList: this.getListView,
      // 可选项，下拉刷新回调
      onRefresh: () => {
        return new Promise<string>((resolve, reject) => {
          // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
          setTimeout(() => {
            resolve('刷新成功');
          }, 2000);
        });
      },
      // 可选项，上拉加载更多回调
      onLoadMore: () => {
        return new Promise<string>((resolve, reject) => {
          // 模拟网络请求操作，请求网络2秒后得到数据，通知组件，变更列表数据
          setTimeout(() => {
            resolve('');
          }, 2000);
        });
      },
      customLoad: null,
      customRefresh: null,
    })
  }

  @Builder
  FailLayout() {
    Image($r('app.media.none'))
      .height(Const.NewsListConstant_NONE_IMAGE_SIZE)
      .width(Const.NewsListConstant_NONE_IMAGE_SIZE)
    Text($r('app.string.page_none_msg'))
      .opacity(Const.NewsListConstant_NONE_TEXT_opacity)
      .fontSize(Const.NewsListConstant_NONE_TEXT_size)
      .fontColor($r('app.color.fontColor_text3'))
      .margin({ top: Const.NewsListConstant_NONE_TEXT_margin })
  }

  @Builder
  private getListView() {
    List({ scroller: this.scroller }) {
      ListItem() {
        BannerItem()
      }

      ListItem() {
        ArticleTopItem()
      }

      ForEach(this.data, (item: ArticleBean) => {
        ListItem() {
          ArticleItem({ articleBean: item })
        }
        .backgroundColor($r('app.color.white'))
      }, (item: ArticleBean, index?: number) => JSON.stringify(item) + index)
    }
    .divider({
      color: $r('app.color.dividerColor'),
      strokeWidth: Const.NewsListConstant_LIST_DIVIDER_STROKE_WIDTH,
      endMargin: Const.NewsListConstant_LIST_MARGIN_RIGHT
    })
    .edgeEffect(EdgeEffect.None) // 必须设置列表为滑动到边缘无效果
  }
}