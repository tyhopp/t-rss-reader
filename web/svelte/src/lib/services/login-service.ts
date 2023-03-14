import { LoginService } from 't-rss-reader/services/login-service';
import { PUBLIC_LOGIN_API } from '$env/static/public';

const LoginServiceInstance = new LoginService(PUBLIC_LOGIN_API);

export { LoginServiceInstance as LoginService };
