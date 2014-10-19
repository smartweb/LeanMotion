module LeanMotion
  class CloudQuery < AVQuery
    
    def setClassObject(classObject)
      @classObject = classObject
      self
    end

    def initWithClassNameAndClassObject(className, classObject:myClassObject)
      @className = className
      self.initWithClassName(className)
      self.setClassObject(myClassObject)
      self
    end

    def findByHash(hash)
      hash.each do |k, v|
        symbols = [:gt, :greater, :lt, :less, :gte, :greater_and_equal, 
                   :lte, :less_and_equal, :bt, :between]

        if v.class == Array && (symbols.include? v[0])
          compare(k, v)
        else
          equal(k, v)
        end
      end
      self
    end

    def equal(k, v)
      if v.nil?
        self.whereKeyDoesNotExist(k)
      elsif v == :exist
        self.whereKeyExists(k)
      else
        self.whereKey(k, equalTo:v)
      end
    end

    def compare(k, v)
      type  = v[0]
      value = v[1]
      case type
      when :gt, :greater
        self.whereKey(k, greaterThan: value)
      when :lt, :less
        self.whereKey(k, lessThan: value)
      when :gte, :greater_and_equal
        self.whereKey(k, greaterThanOrEqualTo: value)
      when :lte, :less_and_equal
        self.whereKey(k, lessThanOrEqualTo: value)
      when :bt, :between
        self.whereKey(k, greaterThan: v[1])
        self.whereKey(k, lessThan: v[2])
      end
      self
    end

    def find(&block)
      return self.findObjects.map {|obj| @classObject.new(obj)} unless block_given?
       
      self.findObjectsInBackgroundWithBlock(lambda do |objects, error|
        objects = objects.map {|obj| @classObject.new(obj)} if objects
        block.call(objects, error)
      end)
    end

    def first(&block)
      return @classObject.new(self.getFirstObject) unless block_given?

      self.getFirstObjectInBackgroundWithBlock(lambda do |object, error|
        obj = @classObject.new(object) if object
        block.call(obj, error)
      end)
    end

    def get(id, &block)
      return @classObject.new(self.getObjectWithId(id)) unless block_given?

      self.getObjectInBackgroundWithId(id, block:lambda do |object, error|
        obj = @classObject.new(object) if object
        block.call(obj, error)
      end)
    end

    def count(&block)
      return self.countObjects unless block_given?

      self.countObjectsInBackgroundWithBlock(lambda do |count, error|
        block.call(count, error)
      end)
    end

    def destroy(&block)
      self.deleteAllInBackgroundWithBlock(lambda do |objects, error|
        block.call(objects, error)
      end)
    end

    def page(number, pagesize=20)
        number ||= 1
        self.limit = pagesize
        self.skip  = (number - 1) * pagesize
        self
    end

    def sort(hash)
      key = hash.first[0]
      sort= hash.first[1]
      if sort == :asc
        self.orderByAscending(key)
      else
        self.orderByDescending(key)
      end
      self
    end

  end

end
