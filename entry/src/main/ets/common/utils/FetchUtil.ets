import axios, { AxiosResponse } from '@ohos/axios';
import { ResponseResult } from '../../viewmodel/ArticleViewModel';
import { CommonConstant } from '../constant/CommonConstant';

export enum TYPE {
  GET,
  POST
}

declare type FetchParams = {
  url?: string;
  method?: TYPE;
};

export function fetch(params: FetchParams): Promise<ResponseResult> {

  const { url,method = TYPE.GET } = params || {};
  let serverData: ResponseResult = new ResponseResult();
  if (method === TYPE.GET) {
    return axios.get<ResponseResult, AxiosResponse<ResponseResult>, null>(url)
      .then((response: AxiosResponse<ResponseResult>) => {
        if (response.status === CommonConstant.HTTP_CODE_200) {
          let resultJson: ResponseResult = response.data;
          if (resultJson.errorCode === CommonConstant.SERVER_CODE_SUCCESS) {
            serverData.data = resultJson.data;
          }
          serverData.errorCode = resultJson.errorCode;
          serverData.errorMsg = resultJson.errorMsg;
        } else {
          serverData.errorMsg = `${$r('app.string.http_error_message')}&${response.status}`;
        }
        return serverData;
      })
      .catch(() => {
        serverData.errorMsg = $r('app.string.http_error_message');
        return serverData;
      })
  } else {
    return null;
  }
}