class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

    def configure_permitted_parameters
      added_attrs = [:username, :email, :password, :password_confirmation, :remember_me, :bio ,:avatar]
      devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
      devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    end

    #400 bad request (i dati passati dal client sono incorretti)
    def render_400
      render file: 'public/400.html', layout: false, status: :bad_request
    end

    # 401 unauthorized (The request has not been applied because it lacks valid authentication credentials for the target resource.)
    def render_401
      render file: 'public/401.html', layout: false, status: :unauthorized
    end

    # 403 forbidden (The server understood the request but refuses to authorize it.)
    def render_403
      render file: 'public/403.html', layout: false, status: :forbidden
    end

    # 404 not found (non trovo ciò che cerchi)
    def render_404
      render file: 'public/404.html', layout: false, status: :not_found
    end
   
    # 500 internal server error (un problema col server non gli ha permesso di portare a termine la richiesta)
    def render_500
      render file: 'public/500.html', layout: false, status: :internal_server_error
    end

end
