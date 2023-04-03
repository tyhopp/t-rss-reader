import { AuthorizedService } from './authorized-service';

export class LastAccessService extends AuthorizedService {
  constructor(api: string) {
    super();
    this.api = api;
  }

  api: string;

  async putLastAccess(): Promise<Response> {
    const options: RequestInit = {
      method: 'PUT',
      headers: await this.headers()
    };

    return await fetch(this.api, options);
  }
}
