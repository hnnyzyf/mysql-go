package ast

//定义一个Node，定义vistor访问方式，该Node可以接受vistor，vistor会遍历这个节点
type Node interface {
	//每一个Node都需要能接受一个Visitor进行访问
	//返回的Node是由Vistor来定义的
	//bool表示是否要继续访问下一个节点
	Accept(v Visitor) (Node, bool)

}

//实现walk为vistor，该vistor对当前的Node进行处理，给出我们想要的操作
type Visitor interface {
	//判断Node是否需要访问
	//使用switch判断节点是否需要访问自己的子节点
	Notify(Node) bool
	//处理节点
	//返回处理后的新的节点以及是否继续往下运行
	Visit(Node) (Node, bool)
}

//定义Node节点的一系列Set方法
type Set interface{
	//node实现:设置类型
	SetTag(a AstOption)
	//node实现:设置collate
	SetCollate(s string)
	//node实现，设置text
	SetText(s string)
	//node实现，设置别名
	SetAlias(s string)
	//node实现，设置顺序
	SetAsc(s string)
	//node实现，获得类型
	GetTag() AstOption
}

//定义节点的array
type List []Node

type AstOption int

const (
	_ AstOption = iota
	AST_SELECT_SIMPLE
	AST_SELECT_UNION
	AST_SELECT_INTERSECT
	AST_SELECT_EXCEPT

	AST_EXPR_OR
	AST_EXPR_DOUBLE_OR
	AST_EXPR_XOR
	AST_EXPR_AND
	AST_EXPR_DOUBLE_AND
	AST_EXPR_NOT
	AST_EXPR_EXCLAMATION_MARK

	AST_EXPR_TRUE
	AST_EXPR_FALSE
	AST_EXPR_UNKNOWN
	AST_EXPR_NULL

	AST_EXPR_LEG
	AST_EXPR_E
	AST_EXPR_GE
	AST_EXPR_G
	AST_EXPR_LE
	AST_EXPR_L
	AST_EXPR_LG
	AST_EXPR_NE

	AST_EXPR_BETWEEN
	AST_EXPR_SOUND_LIKE
	AST_EXPR_LIKE
	AST_EXPR_REGEXP
	AST_EXPR_VETICEL
	AST_EXPR_AMPERSAND
	AST_EXPR_SL
	AST_EXPR_SR
	AST_EXPR_PLUS
	AST_EXPR_MINUS
	AST_EXPR_MULT
	AST_EXPR_DIV
	AST_EXPR_MOD
	AST_EXPR_IN
	AST_EXPR_TILDE

	AST_EXPR_CASE
	AST_EXPR_WHEN
	AST_EXPR_ELSE

	AST_EXPR_COLUMN
	AST_EXPR_COLUMN_STAR
	AST_EXPR_DOUBLE_AT_COLUMN
	AST_EXPR_SINGLE_AT_COLUMN

	AST_SUBQUERY
	AST_SUBQUERY_SOME
	AST_SUBQUERY_ALL
	AST_SUBQUERY_ANY
	AST_SUBQUERY_IN
	AST_SUBQUERY_EXISTS

	AST_TIME_PLUS
	AST_TIME_MINUS
	AST_TIME_INTERVAL

	AST_VALUE_STRING
	AST_VALUE_DOUBLE_QUOTA_STRING
	AST_VALUE_IDENT
	AST_VALUE_NUMBER
	AST_VALUE_MARKER
	AST_VALUE_BIT_NUMBER
	AST_VALUE_HEX_NUMBER
	AST_VALUE_SINGLE_QUOTA_STRING
	AST_VALUE_TRUE
	AST_VALUE_FALSE
	AST_VALUE_NULL

	AST_CLAUSE_DISTINCT
	AST_CLAUSE_DISTINCTROW

	AST_RELATION

	AST_JOIN
	AST_INNER_JOIN
	AST_STRAIGHT_JOIN
	AST_LEFT_JOIN
	AST_RIGHT_JOIN
	AST_NATURAL_LEFT_JOIN
	AST_NATURAL_RIGHT_JOIN

	AST_EXPR_FUNC
	AST_EXPR_CAST
	AST_EXPR_CONVERT_TYPE
	AST_EXPR_CONVERT_ALIAS
	
	AST_EXPR_AVG
	AST_EXPR_AVG_DISTINCT
	AST_EXPR_AVG_DISTINCTROW
	AST_EXPR_AVG_ALL
	AST_EXPR_COUNT
	AST_EXPR_COUNT_DISTINCT
	AST_EXPR_COUNT_DISTINCTROW
	AST_EXPR_COUNT_ALL
	AST_EXPR_MAX
	AST_EXPR_MAX_DISTINCT
	AST_EXPR_MAX_DISTINCTROW
	AST_EXPR_MAX_ALL
	AST_EXPR_MIN
	AST_EXPR_MIN_DISTINCT
	AST_EXPR_MIN_DISTINCTROW
	AST_EXPR_MIN_ALL
	AST_EXPR_SUM
	AST_EXPR_SUM_DISTINCT
	AST_EXPR_SUM_DISTINCTROW
	AST_EXPR_SUM_ALL
	AST_EXPR_COUNT_STAR


	AST_ITEM_DOUBLE_QUOTA_STRING
)
