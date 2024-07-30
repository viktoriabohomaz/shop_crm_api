module OAuth2
  module Providers
    class Base
      def initialize(token)
        @token = token
      end

      def user_info
        raise NotImplementedError, 'Should implement `user_info`'
      end

      protected

      attr_reader :token
    end
  end
end
