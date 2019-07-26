
####################                               19章---面向对象编程                             ##################################


# 数据类型与类连接

	perl OOP最大的特点之一就是可以把基本数据类型（标量、数组、哈希表、文件句柄）与类连接起来

	use doubler;
	tie $data,'doubler',$$;


# 面向对象编程的私有性

	在perl中，可以把方法和数据放入类中，这并不能保证它们的私有性


# 覆盖基类方法

	有时候，可以重新定义从基类继承的方法

	package class1;

	sub printem {
	
		print "hello\n";
	}


	package class2;
	use class1;
	@ISA = qw(class1);

	sub new {
		my $self = {};
		bless $self;
		return $self;
	}
		
	sub printem {
	
		print "Hi\n";
	
	}


	use class2;
	my $object = class2 -> new();
	$object -> printem;     ## Hi, 覆盖基类printem的方法


# 访问已覆盖的基类方法 -------使用SUPER类

	在覆盖了派生类的方法之后，也希望调用已覆盖的方法，以便基类能够完成正确的初始化



	package class2;
	use class1;
	@ISA = qw(class1);

	sub new {
		my $self = {};
		bless $self;
		return $self;
	}
		
	sub printem {
		$self = shift;
		$self -> SUPER::printem;	# 调用基类的方法
		print "Hi\n";
	
	}


	use class2;
	my $object = class2 -> new();
	$object -> printem;      # hello hi



# 标量与类相连接

	perl允许你把变量和一个类相连接，这样通过自动调用已连接类中的方法，将会设置这些变量中存储的值。通过把一个变量连接到某类，就可以自定义该标量中存储的值


	package doubler;

	sub tiescalar {
		
		my $class = shift;
		$data = shift;
		return bless \$data,$class;
	
	}


	sub fetch {
	
		my $self = shift;
		return 2 * $data;
	
	
	}


	sub store {
		my $self = shift;
		$data = shift;
		return 2 * $data;
	}


	sub destroy { }

	return 1;


	use douber;
	tie $data,'doubler',$$;
	$data = 5;

	print $data;   # 10  


# 数组与类相连接
	package darray;

	sub tiearray {
		my $class = shift;
		@array = @_;
		return bless \@array,$class;
	}
	
	sub fetch {
		my $self = shift;
		my $index = shift;
		return 2 * $array[$index];
	}


	use darray;
	tie @array,'darray',(1,2,3);
	print join (", ", @array);        # 2, 4, 6




# 哈希与类相连接（略）


# 使用perl UNIVERSAL类
	
	如果其他人编写的代码给我传递一个对象，但我不信任它，怎样才能知道它是哪个类的对象呢？此时就要使用UNIVERSAL类的isa方法

	在perl中，所有类都共享一个基类：UNIVERSAL

	# isa方法用于检查对象的或者类的 @ISA 数组

	use Math::Complex;
	$opreand = Math::Complex -> new (1,2);

	if ($opreand -> isa("Math::Complex")) {
	
			print "\$opreand is an objec of class Math::Complex.";
	}
	

	# can方法查看它的文本参数是否是类中可调用方法的名字，如果是这样，则返回一个到该方法的引用

	$object = class -> new;
	
	$printemcall = $object -> can('printem');

	&{$printemcall} if $printemcall;   # hello

	package class1;

	sub new {
	
		my $self = {};
		bless $self;
		return $self;
	}

	sub printem {
		print "hello\n";
	}


	# VERSION方法检查类或对象是否已经定义了一个 $VERSION 包全局变量，它包含版本号



	package class1;
	
	$VERSION = 1.01;
	sub new {
	
		my $self = {};
		bless $self;
		return $self;
	}

	sub printem {
		print "hello\n";
	}


	use class1;
	$object = class1 -> new;
	print $object -> VERSION;     # 1.01


# 用闭包创建私有数据


	使用闭包可以按照某种方式存储数据，使对象之外的方法不能访问它，使自己的实例数据变为私有

	package class1;

	sub new {
		my $self = {};
		$self -> {NAME} = "christine";
		
		my $closure = sub {		# 匿名子程序引用

					$self -> {NAME} = @_[1];
					return $self -> {NAME};
				}
		bless $closure;
		return $closure;
	
	}

	
	use class1;					

	my $object = &{class1 -> new()};   # 可以这样直接引用
	

	
	# 同时也可以直接构建实例方法

	sub name {
	
		&{$_[0]};
	}

	
	# 接下来可以直接使用name方法获取私有数据 (实例方法第一个参数是当前对象的引用，构造函数第一个参数是类名)

	my $object = class1 -> new();
	$object -> name('NANCY')


# 数据成员用作变量


	在 C++ 中，把对象的数据成员看作变量，不用把自己的实例数据存储在哈希表或类似的其他表中。在perl中，使用 Alias模块，可以把对象的哈希表 中的实例数据看作个别变量

	# 标准的perl类

		package class1;

		sub new {
			my $self = {};
			$self -> {NAME} = "nancy";
			bless $self;
			return $self;
		}
		
		return 1;

		
		use class1;
		my $object = class1 -> new();
		$object -> {NAME};



	# 使用 Alias 模块的attr函数，把对象的数据哈希表转换为一组对应于哈希表中键的变量

		use class1;
		use Alias;
		
		my $object = class1 -> new();

		attr $object;  # 这个例子中，数据哈希表中只有一个键 NAME，attr函数会创建一个名为 $NAME的新变量

		print $NAME;  # 这样可以把实例数据项看作真正的实例变量，使编程更容易


# 在类中运算符重载

	运算符重载与函数重载相似，其目的是设置某一运算符，让它具有另一种功能
	
	当重载运算符来处理特殊类型的对象时，需指定该运算符应该如何处理这种对象。当为某种类型的对象重载运算符时，这些对象可以与该运算符一起使用
	使用 overload 模块附注重载运算符

	要重载运算符，应该把一个方法连接到运算符


	package class1;

	use overload
		"+" => \&add;
		"-" => \$substract;

	sub new {
		shift;
		my $self = {};
		$self -> {DATA} = shift;
		bless $self;
		return $self;
	}

	sub get_data {
		my $self = shift;
		return $self -> {DATA};
	}

	# 现在实现add方法，它会把class1类的两个对象加起来。当重载一个二元运算符时，会传递两个对象，以便与该运算符一起使用

	sub add {
	
		my ($obj1,$obj2)  @_;

		my $opreand1 = ref $obj1 eq 'class1' ? $obj1 -> {DATA} : $obj1;
		my $opreand2 = ref $obj1 eq 'class1' ? $obj2 -> {DATA} : $obj2;

		my $new_object = class1 -> new($opreand1 + $opreand2);
		return $new_object;
	}

	# add 方法应该返回class1类的新对象（当对该类的两个对象做加法运算时，应该结束于同一个类的新对象）

	
	use class1;
	my $object1 = class1 -> new(1);
	print $object1 -> get_data."\n";

	my $object2 = class1 -> new(2);
	print $object2 -> get_data."\n";

	$object3 = $object1 + $object2;
	print $object3 -> get_data."\n";

