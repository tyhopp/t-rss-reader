import { AuthorizedService } from './authorized-service';
import { PUBLIC_FEEDS_API } from '$env/static/public';

export class FeedsService extends AuthorizedService {
  async deleteFeed(url: string): Promise<Response> {
    const headers = await this.headers();

    return await fetch(PUBLIC_FEEDS_API, {
      method: 'DELETE',
      headers,
      body: JSON.stringify({ url })
    });
  }

  async getFeeds(): Promise<Response> {
    const headers = await this.headers();

    return await fetch(PUBLIC_FEEDS_API, {
      method: 'GET',
      headers
    });
  }

  async putFeed(url: string, name: string): Promise<Response> {
    const headers = await this.headers();

    return await fetch(PUBLIC_FEEDS_API, {
      method: 'PUT',
      headers,
      body: JSON.stringify({ url, name })
    });
  }
}

export default new FeedsService();
