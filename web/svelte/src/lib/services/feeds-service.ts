import { FeedsService } from 't-rss-reader/services/feeds-service';
import { PUBLIC_FEEDS_API } from '$env/static/public';

const FeedsServiceInstance = new FeedsService(PUBLIC_FEEDS_API);

export { FeedsServiceInstance as FeedsService };
