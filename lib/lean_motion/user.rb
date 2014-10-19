module LeanMotion
  module User
    attr_accessor :AVUser

    RESERVED_KEYS = ['username', 'password', 'email']

    def initialize(av_user_object=nil)
      if av_user_object
        @AVUser = av_user_object
      else
        @AVUser = AVUser.user
      end
    end

    def method_missing(method, *args, &block)
      if RESERVED_KEYS.include?("#{method}")
        @AVUser.send(method)
      elsif RESERVED_KEYS.map {|f| "#{f}="}.include?("#{method}")
        @AVUser.send(method, args.first)
      elsif fields.include?(method)
        @AVUser.objectForKey(method)
      elsif fields.map {|f| "#{f}="}.include?("#{method}")
        method = method.split("=")[0]
        @AVUser.setObject(args.first, forKey:method)
      elsif @AVUser.respond_to?(method)
        @AVUser.send(method, *args, &block)
      else
        super
      end
    end

    def fields
      self.class.send(:get_fields)
    end

    def sign(&block)
      return true unless block_given?
      @AVUser.signUpInBackgroundWithBlock(lambda do |succeeded, error|
          block.call(succeeded, error)
      end)
    end

    module ClassMethods
      
      def login(username, password, &block)
        AVUser.logInWithUsernameInBackground(username, password:password, block:lambda do |user, error|
          block.call(user, error)
        end)
      end


      def query
          LeanMotion::CloudQuery.alloc.initWithClassNameAndClassObject('_User', classObject:self)
      end

      def count(&block)
        cloud_query = query
        return cloud_query.countObjects unless block_given?

        cloud_query.countObjectsInBackgroundWithBlock(lambda do |count, error|
          block.call(count, error)
        end)
      end

      def where(hash)
        cloud_query = query
        cloud_query.findByHash(hash)
      end
      
      def first(&block)
        cloud_query = query
        return cloud_query.getFirst unless block_given?

        cloud_query.getFirstObjectInBackgroundWithBlock(lambda do |object, error|
          block.call(object, error)
        end)
      end

      def order(hash)
        cloud_query = query
        key = hash.first[0]
        sort= hash.first[1]
        if sort == :asc
          cloud_query.orderByAscending(key)
        else
          cloud_query.orderByDescending(key)
        end
      end

      def page(number, pagesize=20)
        number ||= 1
        cloud_query = query
        cloud_query.limit = pagesize
        cloud_query.skip  = (number - 1) * pagesize
        cloud_query
      end

      def fields(*args)
        args.each {|arg| field(arg)}
      end

      def field(name)
        @fields ||= []
        @fields << name
      end

      def current_user
        if AVUser.currentUser
          u = new
          u.AVUser = AVUser.currentUser
          return u
        else
          return nil
        end
      end

      def all(&block)
        return AVUser.query.findObjects.map {|obj| self.new(obj)} unless block_given?

        AVUser.query.findObjectsInBackgroundWithBlock(lambda do |objects, error|
          objects = objects.map {|obj| self.new(obj)} if objects
          block.call(objects, error)
        end)
      end

      def get_fields
        @fields
      end

    end

    def self.included(base)
      base.extend(ClassMethods)
    end

  end
end
