#!usr/bin/perl -w

#####################                          18章 ---  创建类和对象       ###############################################
BEGIN {

	unshift @INC,'/home/zhi/perl_parctice/perl_write';
}

use cocoa;

# 创建对象有多种方法
$cup = new cocoa;
$cup1 = cocoa -> new();
$cup2 = cocoa::new();
print $cup."\n";
print $cup1."\n";
print $cup2."\n";

#实际上上面创建的对象不是十分有用，因为它没有存储成员数据，并且也不支持任何方法。


#方法

#方法是建于类内部的子程序，因而建于该类创建的对象内部
#如果有支持方法的对象，可以按照下面的方式使用该对象的方法

$results = $object1 -> calculate($operand1,$operand2); 		#使用calculate方法处理$operand1和$operand2中的两个数值



#perl有两种类型的方法：类方法和实例方法
	
	# 实例方法针对对象调用（即对象是类的实例），而且把对象的引用传递给他，作为第一个参数，对于上例而言实际上calculate有三个参数\
	  #对象的引用，后面有两个操作数。使用对象引用，可以知道什么对象调用了该方法
	
	# 类方法针对类调用，而且把类名传递给它作为第一个参数,如new()的构造函数就是一个类方法




# 快速创建类

package class1;
return 1;

# 创建到类中的方法---使用构造函数创建对象

package class1;

sub new {

	... ;  #需要某事物作为该对象的基础来bless且返回，通常使用匿名哈希
}
return 1;


# 该构造函数创建一个新的匿名哈希表，bless该哈希表到当前对象中，并返回对构造函数的调用者哈希表的引用
# 使用bless函数，这个引用被看作对对象本身的引用
package class1;

sub new {

	my $self = {};
	bless $self;    # 把哈希表bless到当前对象
	return $self;
}
return 1;

# 传递数据到构造函数

	# 构造函数不只是用于创建对象，还可以初始化对象

	package class1;

	sub new {
		my $self = {};
		shift;    # 传递给构造函数的第一项是其类的名称
		$self -> {DATA_ITEM_1} = shift;
		$self -> {DATA_ITEM_2} = shift;
		bless $self;
		return $self;
	}

	return 1;




# 以上，我们已经创建了类和类构造函数。如何创建类的对象？

# 从类创建对象---调用构造函数，返回新对象的引用

my $object = class1 -> new();     #通过构造函数创建了新对象，并且该对象的引用存储到了$object1中，用类名来限定new方法调用: class1 -> new



# 传递数据到构造函数，有些构造函数用它们的数据来初始化对象

	# 如上面那段代码，该构造函数取用两个参数，并用键DATA_ITEM_1和DATA_ITEM_2把这两个参数存储到对象的内部哈希中

	my $object1 = class1 -> new(1,2);
	
	print "DATA_ITEM_1 = ", $object1 -> {DATA_ITEM_1},"\n";
	print "DATA_ITEM_2 = ", $object1 -> {DATA_ITEM_2},"\n";


# 现在我们已经创建了几个对象，然而这样的对象没有多大用处，除非它们支持方法


# 创建类对象

	# 我们已经创建了对象，但是，对象看起来什么也不能做，我们只是创建这种新类型的对象，怎么办呢，下一步是添加方法到对象
	
	# 使用类名调用类方法，使用对象引用调用实例方法（对象是类的实例）。


	# 调用类方法，类名本身作为第一个参数传递到该方法





# 创建对象方法（实例方法）
	#不想把类作为一个整体的方法，想创建可以使用某个特殊对象来开始数据处理的方法------> 创建实例方法

	

	package class1;

	sub new {
		my $self = {};
		shift;    # 传递给构造函数的第一项是其类的名称
		$self -> {DATA_ITEM_1} = shift;
		$self -> {DATA_ITEM_2} = shift;
		bless $self;
		return $self;
	}


	sub addem {
	
		my ($object,$operand1,$operand2) = @_;
		return $operand1 + $operand2;
	}

	return 1;

	
	# 如果想使用对象内部的数据，应当使用对象引用来得到该数据

	sub data {
		my $self = shift;
		if (@_) {$self -> {DATA} = shift};
		return $self -> {DATA};
	}




# 调用方法

	# 1. 使用 -> 运算符


	# 2. 在类内的代码中使用 -> 中缀反引用符，在构造函数内初始化一个数据项为0

	sub new {
		my $self = {};
		bless $self;
		$self -> data(0);
		return $self;
	
	}

	sub data {
		my $self = shift;
		if (@_) {$self -> {DATA} = shift};
		return $self -> {DATA};
	}

	# 3. 第二种方式，如果代码在类里，还可以使用下面的语法做前面的方法调用

	sub new {
		my $self = {};
		bless $self;
		data ($self,0);
	}	return $self;


# 在对象内存储数据（实例变量）
	# 我们能够在类中创建各种方法了，但是还有一个方法，如何在对象内存储数据呢？

	# 存储于对象内的数据称为对象数据，或实例数据（因为对象是类的实例）

	# 在对象中存储实例数据的一种方法（事实上，最常用的方法）是：在对象中创建一个匿名哈希表，并通过键存储数据值



	sub new {
		my $self = {};
		$self -> {NAME} = "christine";
		bless $self;
		return $self;
	}

	# 现在创建该类的对象时，可以这样引用数据中的数据
	
	use class1;
	my $object = class1 -> new();

	print $object -> {NAME}."\n";


	# perl通常把数据藏到访问方法之后，这意味着不能直接检索到数据，需要创建且使用getdata方法，来访问当前数据的数值


# 创建数据访问方法

	# 使用数据访问方法来限制对对象的实例数据的访问。通常创建一对方法-----get方法和set方法来提供对数据的访问

	sub get_name {
	
		$self = shift;
		return $self -> {NAME};
	}

	sub set_name {
		$self = shift;
		$self -> {NAME} = shift;
	
	}

	# 上面的代码，其他程序员编写的代码可以获得匿名哈希表中的NAME元素，如果实在想要数据私有，最好在创建对象时，不把数据作为实例数据存储到被bless的哈希表中。可能考虑把数据作为类变量存储


	package class2;

	my $name = "christine";

	sub new {
		my $self = {};
		bless $self;
		return $self;
	}
	
	sub get_name {
		return $name;
	}

	sub set_name {
	
		shift;
		$name = shift;
	}

	return 1;
	
	# 现在，可以通过数据访问方法不直接地访问数据

	use class2;

	my $object -> set_name('Nancy');

	# 存在一个问题，因为这是一个类变量，所以它没有限制到特殊的对象，相反，它为该类所有存在的对象所共享，如果不想使用共享的类变量来确保数据私有化，该怎么办呢？比较好的方法是使用闭包使数据真正私有化

	
# 创建析构函数
 	#我们知道了可以使用构造函数来初始化对象，但是处理对象后，如何执行清除工作呢? ---------- 使用析构函数DESTROY
	
	sub new {
		my $self = {};
		bless $self;
		return $self;
	}

	sub DESTROY {
		print "object is being destroyed\n";
	}


# 实现类继承

	# 我们不总是自定义所有的类，因为要重写如此多的代码。更好的方法是创建一个基类，在该基类中包含尽可能多的、所有类的通性

	# 面向对象编程一个重要的方面是继承，通过继承可以创建类的库

	# 派生类可以继承基类
	

	package class1;

	sub new {
		my $self = {};
		bless $self;
		return $self;
	}

	sub gettex { return "hello\n"};
	return 1;

	package class2;
	use class1;
	@ISA = qw (class1);

	sub new {
		my $self = class1 -> new;
		bless $self;
		return $self;
	}
	return 1;


	#这样就实现了class2从class1继承了gettex方法，实际上这种方法并非真正意义上的继承，创建的$object1对象实际上是class1的对象


# 继承构造函数

	基于上面的例子，创建派生类对象时，对象是基类的对象，不是派生类的，因此，需要学习继承构造函数

	package class1;

	sub new {
		my $class = shift;
		my $self = {};
		bless ($self,$class);    # 对bless进行改变
		return $self;
	}


	package class2;

	use class1;
	@ISA = qw (class1);

	sub new {
		my $self = class1 -> new;
		bless $self;
		return $self;
	}

	
	# 这样的话，创建的对象确实是class2的


# 继承实例数据
	除了方法之外，从基类派生类时，还继承了基类的数据，perl推荐在基类的哈希表内存储继承的数据

	package class1;

	sub new {
		my $class = shift;
		my $self = {};
		$self -> {NAME} = "christine";
		bless $self,$class;
		return $self;
	}

	package class2;
	use class1;
	@ISA = qw(class1);

	sub new {
		my $self = class1 -> new();
		$self -> {DATA} = 200;
		return $self;
	}

# 多重继承

	在perl中，派生类可以继承一个以上的基类，只需在@ISA数组中列出想要继承的类

	package class0;
	sub printhi {print "HI\n"};

	package class1;
	sub printhello {print "hello\n"};

	# 在class2中同时继承class0和class1

	package class2;
	use class0;
	use class1;
	@ISA = qw (class0,class1);

	sub new {
		my $self = {};
		bless $self;
		return $self;
	}



	use class2;
	my $object1 = class2 ->new();

	$object1 -> printhi;
	$object1 -> printhello;
