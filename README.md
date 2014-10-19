# LeanMotion

LeanMotion 是一个RubyMotion的Gem，可以更加方便地使用LeanCloud SDK。用更Ruby的写法来操作LeanCloud的数据，类Rails的ActiveRecord，增删查改。

## 安装说明

1、安装gem
```
gem install lean_motion
```

2、创建项目
```
lean_motion create app-name
```

3、设置LeanCloud的App ID和App Key
修改 app_delegate.rb

```
    app_id   = "your_app_id"
    app_key  = "your_app_key" 
```

4、运行
```
rake
```

## 使用说明
1、在LeanCloud后台创建一个Class，比如Product，并添加以下字段
```
name: String
description: String
url: String
```

2、添加model文件 product.rb，建议放在app/models/目录下
```
class Product
  include LM::Model

  fields :name, :description, :url
end
```

3、操作数据

新建产品
```
product = Product.new
product.name 		= 'iPhone 6'
product.description = '目前最好的智能手机'
product.url 		= 'http://www.apple.com'
product.save
```

产品数量
```
Product.count
```

查询产品
```
Product.where(:name=>'iPhone 6').find
```

获得第一条记录
```
Product.first
```

排序
```
Product.sort(:createdAt=>:desc).find
```
