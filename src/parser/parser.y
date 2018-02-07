//头文件
%{
package parser

import "ast"

%}


//类型定义
%union {
  ident       	string 	
  str 			string
  val  			string	
  node          ast.Node
  expr 			ast.ExprNode
  list 			ast.List
}

//token定义
%token <ident> 
     	BuiltinCharacterIdent
     	BuiltinFucTimeAddIdent
     	BuiltinFucTimeSubIdent
     	BuiltinTimeUnitIdent
     	IDENT

%token <str>
      	DOUBLE_QUOTA_STRING
      	PARAM_MARKER
      	SINGLE_QUOTA_STRING
      	STRING

%token <val> 
      	BIT_NUMBER 
      	HEX_NUMBER
      	NUMBER 
		
%token <ident> 
      	ALL
      	ANY
      	AS
      	ASC
      	AVG
      	BY
      	CHARACTER
      	COMMENT
      	COUNT
      	DESC
      	DISTINCT
      	DISTINCTROW
      	FALSE
      	FOR
      	FROM
      	GROUP
      	HAVING
      	IF
      	INTO
      	LIMIT
      	LOCK
      	MAX
      	MIN
      	MODE
      	NULL
      	OFFSET
      	ORDER
      	QUARTER
      	SELECT
      	SET
      	SHARE
      	SOME
      	SOUNDS
      	SUM
      	TO
      	TRUE
      	UPDATE
      	WHERE
      	CAST
      	CONVERT


//类型定义
%type <node>
      	distinct_clause
      	for_locking_clause
      	from_clause
      	group_clause
      	having_clause
      	into_clause
      	opt_for_locking_clause
      	opt_select_limit
      	opt_sort_clause
      	select_clause
      	select_limit
      	select_no_parens
      	select_stmt
      	select_with_parens
      	simple_select
      	sort_clause
      	where_clause

%type <val>
     	alias
     	alias_name
     	all_or_distinct
     	asc_or_desc
     	cast_type
     	collation_name
     	comparison_operator
     	db_name
     	double_at_ident
     	func_name
     	func_name_time_add
     	func_name_time_sub
     	identifier
     	identifier_or_star
     	inner
     	is_or_not
     	join_type
     	keyword_as_func
     	opt_alias
     	opt_distinct
     	opt_not
     	outer_opt
     	single_at_ident
     	subquery_type
     	table_name
     	time_unit
     	true_or_false

%type <expr>  
      	agg_expr
      	bit_expr
      	boolean_primary
      	case_arg
      	case_expr
      	column_ref
      	else_arg
      	expr
      	func_expr
      	group_by_item
      	join_qual
      	joined_table
      	literal
      	marker
      	offset_expr
      	predicate
      	relation
      	rows_offset
      	simple_expr
      	sortby
      	table_factor
      	table_ref
      	target_el
      	time_expr
      	variable
      	when_arg

%type <list>
      	expr_list
      	from_list
      	group_by_list
      	limit_list
      	opt_target_list
      	rows
      	sortby_list
      	table_refs
      	target_list
      	when_list
			

//优先级定义
%nonassoc LOW INTERVAL
%left <val>  UNION EXCEPT 
%left <val>  INTERSECT
%left <val>  ','
%left <val>  JOIN STRAIGHT_JOIN LEFT RIGHT INNER OUTER CROSS NATURAL USE
%left <val>  ON USING
%left <val>  OR OO
%left <val> AND AA
%right <val>  NOT
%left <val>  BETWEEN CASE WHEN THEN ELSE
%nonassoc IS
%left <val>  '=' '<' '>' LIKE REGEXP IN GE LE NE LG IE LNE SL SR LEG XOR
%right <val>  EXISTS
%left <val>  '|'
%left <val>  '&' 
%left <val>  '+' '-'
%left <val>  '*' '/' '%' DIV MOD
%left <val>  '^'
%left <val>  '~'
%nonassoc <val>  OP
%right <val> COLLATE
//select_with_parens用于消除所有的(select)形式的语句，需优先将将'(' select_with_parens ')'规约为 select_with_parens,而不是reduce为其他符号
//如果出现shift-reduce冲突，强制给予规约低于')'的优先级,保证规则select_with_parens <---'(' select_with_parens ')' 为第一优先级
%nonassoc <val>  UMINUS
%left <val> '(' ')'
%nonassoc <val>  '.'
%left <val>  END


%start start
%%


start:
			select_stmt
			{
				 yylex.(*Tokener).ParseStmt  = $1
			}

/************************************************************************************
 *
 *  Select Statements
 *
 **********************************************************************************/



select_stmt:
			select_no_parens			%prec UMINUS
			| select_with_parens		%prec UMINUS


select_with_parens:
			'(' select_no_parens ')'				
				{ 
					$$ = $2 
				}
			| '(' select_with_parens ')'
				{ 
					$$ = $2 
				}	

select_no_parens:
			simple_select							
				{ 
					$$ = $1 
				}
			| select_clause sort_clause        		
				{ 

				}
			| select_clause opt_sort_clause for_locking_clause opt_select_limit 
				{	
				}
			| select_clause opt_sort_clause select_limit opt_for_locking_clause  
				{
				}

select_clause:
			simple_select							{ $$ = $1 }
			| select_with_parens					{ $$ = $1 }


simple_select:
			SELECT opt_target_list into_clause from_clause where_clause group_clause having_clause 
				{	
 					stmt := &ast.SelectStmt{}
 					stmt.Target=&ast.TargetClause{Target_ref:$2}
 					if $3!=nil{
 						stmt.Into=$3.(*ast.IntoClause)
 					}
 					if $4!=nil{
 						stmt.From=$4.(*ast.FromClause)
 					}
 					if $5!=nil{
 						stmt.Where=$5.(*ast.WhereClause)
 					}
 					if $6!=nil{
 						stmt.Group=$6.(*ast.GroupClause)
 					}
 					if $7!=nil{
 						stmt.Having=$7.(*ast.HavingClause)
 					}
 					stmt.SetTag(ast.AST_SELECT_SIMPLE)
 					$$ = stmt
				}
			|SELECT distinct_clause target_list into_clause from_clause where_clause group_clause having_clause 
				{	
					stmt:= &ast.SelectStmt{Distinct:$2.(*ast.DistinctClause),Target:&ast.TargetClause{Target_ref:$3}}
 					if $4!=nil{
 						stmt.Into=$4.(*ast.IntoClause)
 					}
 					if $5!=nil{
 						stmt.From=$5.(*ast.FromClause)
 					}
 					if $6!=nil{
 						stmt.Where=$6.(*ast.WhereClause)
 					}
 					if $7!=nil{
 						stmt.Group=$7.(*ast.GroupClause)
 					}
 					if $8!=nil{
 						stmt.Having=$8.(*ast.HavingClause)
 					}
 					stmt.SetTag(ast.AST_SELECT_SIMPLE)
 					$$ = stmt
				}
			| select_clause UNION all_or_distinct select_clause
				{
					stmt:=&ast.SelectStmt{All:$3,Left:$1.(*ast.SelectStmt),Right:$4.(*ast.SelectStmt)}
					stmt.SetTag(ast.AST_SELECT_UNION)
					$$ = stmt
				}
			| select_clause INTERSECT all_or_distinct select_clause
				{
					stmt:=&ast.SelectStmt{All:$3,Left:$1.(*ast.SelectStmt),Right:$4.(*ast.SelectStmt)}
					stmt.SetTag(ast.AST_SELECT_INTERSECT)
					$$ = stmt
				}
			| select_clause EXCEPT all_or_distinct select_clause
				{
          stmt:=&ast.SelectStmt{All:$3,Left:$1.(*ast.SelectStmt),Right:$4.(*ast.SelectStmt)}
					stmt.SetTag(ast.AST_SELECT_EXCEPT)
					$$ = stmt
				}



/*****************************************************************************
 *
 *	expr for SELECT
 *
 *****************************************************************************/

expr:
  			expr OR expr
  			  	{
  			  		expr:= &ast.Expr{Operator:"OR",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_OR)
  			  		$$ = expr
  			  	}
  			| expr OO expr
  			  	{
  			  		expr:= &ast.Expr{Operator:"||",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_DOUBLE_OR)
  			  		$$ = expr
  			  	}
  			| expr XOR expr
  			  	{
  			  		expr:= &ast.Expr{Operator:"XOR",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_XOR)
  			  		$$ = expr
  			  	}
  			| expr AND expr
  			  	{
  			  		expr:= &ast.Expr{Operator:"AND",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_AND)
  			  		$$ = expr
  			  	}
  			| expr AA expr
  			  	{
  			  		expr:= &ast.Expr{Operator:"&&",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_DOUBLE_AND)
  			  		$$ = expr
  			  	}
  			| NOT expr
  			  	{	
  			  		switch node:=$2.(type){
  			  			case *ast.SubqueryExpr:
  			  				node.Not=true
  			  				$$ = node
  			  			default:
  			  				expr:= &ast.Expr{Operator:"NOT",Left:nil,Right:$2}
  			  				expr.SetTag(ast.AST_EXPR_NOT)
  			  				$$ = expr
  			  		}
  			  		
  			  	}
  			| boolean_primary is_or_not true_or_false
  				{
  					expr:= &ast.Expr{Left:$1}
  					if $2=="IS"{
  						expr.Not=true
  					}else{
  						expr.Not=false
  					}
  					switch $3{
  						case "TRUE":
  							expr.SetTag(ast.AST_EXPR_TRUE)
  						case "FALSE":
  							expr.SetTag(ast.AST_EXPR_FALSE)
  						case "UNKNOWN":
  							expr.SetTag(ast.AST_EXPR_UNKNOWN)
  					}

  			  		$$ = expr
  				}
  			| boolean_primary
  				{
  					$$ = $1
  				}

boolean_primary:
  			boolean_primary is_or_not NULL
  			  	{
  			  		expr:= &ast.Expr{Left:$1}
  					if $2=="IS"{
  						expr.Not=false
  					}else{
  						expr.Not=true
  					}
  					expr.SetTag(ast.AST_EXPR_NULL)
  			  		$$ = expr

  			  	}
  			| boolean_primary LEG predicate
  				{
  					expr:= &ast.Expr{Operator:"<=>",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_LEG)
  			  		$$ = expr
  				}
  			| boolean_primary comparison_operator predicate
  				{
  					expr:= &ast.Expr{Operator:$2,Left:$1,Right:$3}
  					switch $2{
  						case "=":
  							expr.SetTag(ast.AST_EXPR_E)
  						case ">=":
  							expr.SetTag(ast.AST_EXPR_GE)
  						case ">":
  							expr.SetTag(ast.AST_EXPR_G)
  						case "<=":
  							expr.SetTag(ast.AST_EXPR_LE)
  						case "<":
  							expr.SetTag(ast.AST_EXPR_L)
  						case "<>":
  							expr.SetTag(ast.AST_EXPR_LG)	
  						case "!=":
  							expr.SetTag(ast.AST_EXPR_NE)
  					}
  			  		$$ = expr
  			  	}
  			| boolean_primary comparison_operator subquery_type select_with_parens
  				{
  					expr:= &ast.SubqueryExpr{Operator:$2,Left:$1,Right:$4.(*ast.SelectStmt)}
  					switch $3{
  						case "SOME":
  							expr.SetTag(ast.AST_SUBQUERY_SOME)
  						case "ALL":
  							expr.SetTag(ast.AST_SUBQUERY_ALL)
  						case "ANY":
  							expr.SetTag(ast.AST_SUBQUERY_ANY)
  					}
  					$$ = expr
  				}
  			| predicate
  				{
  					$$ = $1
  				}

 predicate:
  			bit_expr opt_not IN select_with_parens
  			  	{
  			  		expr:= &ast.SubqueryExpr{Operator:"IN",Left:$1,Right:$4.(*ast.SelectStmt)}
  			  		if $2==""{
  			  			expr.Not=false
  			  		}else{
  			  			expr.Not=true
  			  		}
  			  		expr.SetTag(ast.AST_SUBQUERY_IN)
  			  		$$= expr
  			  	}
  			| bit_expr opt_not IN '(' expr_list ')'
  				{	
  					expr := &ast.InExpr{Left:$1,Right:$5}
  					if $2==""{
  						expr.Not=false
  					}else{
  						expr.Not=true
  					}
  					expr.SetTag(ast.AST_EXPR_IN)
  					$$ = expr
  				}
  			| bit_expr opt_not BETWEEN bit_expr AND predicate
  				{
  					expr:=&ast.BetweenExpr{Expr:$1,Left:$4,Right:$6}
  					switch $2{
  						case "":
  							expr.Not=false
  						case "NOT":
  							expr.Not=true
  					}
  					expr.SetTag(ast.AST_EXPR_BETWEEN)
  					$$ = expr
  				}
  			| bit_expr SOUNDS LIKE bit_expr
  				{
  					expr:= &ast.Expr{Operator:"LIKE",Left:$1,Right:$4}
  			  		expr.SetTag(ast.AST_EXPR_SOUND_LIKE)
  			  		$$ = expr
  				}
  			| bit_expr opt_not LIKE simple_expr
  				{		
  					expr:= &ast.Expr{Operator:"LIKE",Left:$1,Right:$4}
  					switch $2{
  						case "":
  							expr.Not=false
  						case "NOT":
  							expr.Not=true
  					}
  			  		expr.SetTag(ast.AST_EXPR_LIKE)
  			  		$$ = expr
  				}
  			| bit_expr opt_not REGEXP bit_expr
  				{
  					expr:= &ast.Expr{Operator:"REGEXP",Left:$1,Right:$4}
  					switch $2{
  						case "":
  							expr.Not=false
  						case "NOT":
  							expr.Not=true
  					}
  			  		expr.SetTag(ast.AST_EXPR_REGEXP)
  			  		$$ = expr
  				}
  			| bit_expr
  				{
  					$$ = $1
  				}


bit_expr:
  			bit_expr '|' bit_expr
  			  	{	
  			  		expr:= &ast.Expr{Operator:"|",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_VETICEL)
  			  		$$ = expr
  			  	}
  			| bit_expr '&' bit_expr
  				{	
  			  		expr:= &ast.Expr{Operator:"&",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_AMPERSAND)
  			  		$$ = expr
  			  	}
  			| bit_expr SL bit_expr
  				{	
  			  		expr:= &ast.Expr{Operator:"<<",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_SL)
  			  		$$ = expr
  			  	}
  			| bit_expr SR bit_expr
  			  	{	
  			  		expr:= &ast.Expr{Operator:">>",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_SR)
  			  		$$ = expr
  			  	}
  			| bit_expr '+' bit_expr
  			  	{	
  			  		expr:= &ast.Expr{Operator:"+",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_PLUS)
  			  		$$ = expr
  			  	}
  			| bit_expr '-' bit_expr
  			  	{	
  			  		expr:= &ast.Expr{Operator:"-",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_MINUS)
  			  		$$ = expr
  			  	}
  			| bit_expr '*' bit_expr
  				{	
  			  		expr:= &ast.Expr{Operator:"*",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_MULT)
  			  		$$ = expr
  			  	}
  			| bit_expr '/' bit_expr
  			  	{	
  			  		expr:= &ast.Expr{Operator:"/",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_DIV)
  			  		$$ = expr
  			  	}
  			| bit_expr DIV bit_expr
  				{
  					expr:= &ast.Expr{Operator:"DIV",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_DIV)
  			  		$$ = expr
  				}
  			| bit_expr MOD bit_expr
  			 	{
  					expr:= &ast.Expr{Operator:"MOD",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_MOD)
  			  		$$ = expr
  				}
  			| bit_expr '%' bit_expr
  			  	{
  					expr:= &ast.Expr{Operator:"%",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_MOD)
  			  		$$ = expr
  				}
  			| bit_expr '^' bit_expr
  				{
  					expr:= &ast.Expr{Operator:"^",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_XOR)
  			  		$$ = expr
  				}
  			| bit_expr '+' INTERVAL expr time_unit %prec '+'
  				{
  					expr:= &ast.Expr{Operator:"+",Left:$1,Right:$4}
  			  		expr.SetTag(ast.AST_TIME_INTERVAL)
              expr.SetAlias($5)
  			  		$$ = expr
  				}
  			| bit_expr '-' INTERVAL expr time_unit %prec '-'
  				{
  			  		expr:= &ast.Expr{Operator:"-",Left:$1,Right:$4}
  			  		expr.SetTag(ast.AST_TIME_INTERVAL)
              expr.SetAlias($5)
  			  		$$ = expr
  			  	}
  			| simple_expr %prec LOW
  				{
  					$$ = $1
  				}

simple_expr:
			
			//规约数字
  			 literal
  			  	{
  			  		$$ = $1
  			  	}
  			//规约column
  			| column_ref
  				{
              		$$ = $1
  				}
  			//规约系统变量
  			|variable
  				{
  					$$ = $1
  				}
  			| func_expr
  				{
  					$$ = $1
  				}
  			| simple_expr COLLATE collation_name %prec OP
  				{
            $1.SetCollate($3)
  					$$ = $1
  				}
  			| marker
  				{
  					$$ = $1
  				}

  			| simple_expr OO simple_expr %prec OP
  				{
  			  		expr:= &ast.Expr{Operator:"||",Left:$1,Right:$3}
  			  		expr.SetTag(ast.AST_EXPR_DOUBLE_OR)
  			  		$$ = expr
  			  	}
  			| '+' simple_expr	%prec OP
  				{
  					$$ = $2.(*ast.ValExpr)
  				}
  			| '-' simple_expr	%prec OP
  				{
  					val:=$2.(*ast.ValExpr)
  					val.Symbol=0-val.Symbol
  					$$ = val
  				}
  			| '~' simple_expr	%prec OP
  				{
  					expr:= &ast.Expr{Operator:"~",Left:nil,Right:$2}
  			  		expr.SetTag(ast.AST_EXPR_TILDE)
  			  		$$ = expr
  				}
  			| '!' simple_expr 	%prec OP
  			  	{
  					expr:= &ast.Expr{Operator:"!",Left:nil,Right:$2}
  			  		expr.SetTag(ast.AST_EXPR_EXCLAMATION_MARK)
  			  		$$ = expr
  				}
  			| '(' expr ')'
  				{
  					$$ = $2
  				}
  			//降低规约优先级
  			| select_with_parens  		%prec UMINUS
  				{
  					expr:= &ast.SubqueryExpr{Left:nil,Right:$1.(*ast.SelectStmt)}
  					expr.SetTag(ast.AST_SUBQUERY)
  					$$ = expr
  				}
  			| EXISTS select_with_parens
  				{
  					expr:= &ast.SubqueryExpr{Operator:"EXISTS",Left:nil,Right:$2.(*ast.SelectStmt)}
  					expr.SetTag(ast.AST_SUBQUERY_EXISTS)
  					$$ = expr
  				}
  			| case_expr
  				{
  					$$ = $1
  				}

literal:
		    BIT_NUMBER
			   	{
					expr :=&ast.ValExpr{Symbol:1,Sval:$1}
  			  		expr.SetTag(ast.AST_VALUE_BIT_NUMBER)
					$$ = expr
			   	}
		    |HEX_NUMBER
			   	{
			   		expr :=&ast.ValExpr{Symbol:1,Sval:$1}
  		    		expr.SetTag(ast.AST_VALUE_HEX_NUMBER)
			   		$$ = expr
			   }
		    |NUMBER
			   	{
			   		expr :=&ast.ValExpr{Symbol:1,Sval:$1}
  		    		expr.SetTag(ast.AST_VALUE_NUMBER)
			   		$$ = expr
			   	}
			|STRING
				{
			   		expr :=&ast.ValExpr{Symbol:0,Sval:$1}
  		    		expr.SetTag(ast.AST_VALUE_STRING)
			   		$$ = expr
			   	}
			|SINGLE_QUOTA_STRING
				{
			   		expr :=&ast.ValExpr{Symbol:0,Sval:$1}
  		    		expr.SetTag(ast.AST_VALUE_SINGLE_QUOTA_STRING)
			   		$$ = expr
			   	}
			|DOUBLE_QUOTA_STRING
				{
					expr :=&ast.ValExpr{Symbol:0,Sval:$1}
  		    		expr.SetTag(ast.AST_VALUE_DOUBLE_QUOTA_STRING)
			   		$$ = expr
				}
      		|true_or_false
      		  	{
      		  	    expr :=&ast.ValExpr{Symbol:0,Sval:$1}
      		  	    switch $1{
      		  	      case "TRUE":
      		  	         expr.SetTag(ast.AST_VALUE_TRUE)
      		  	      case "FALSE":
      		  	         expr.SetTag(ast.AST_VALUE_FALSE)
      		  	    }
			
      		  	    $$ = expr
      		  	}
      		|NULL
      		  	{
      		  	    expr :=&ast.ValExpr{Symbol:0,Sval:"NULL"}
      		  	    switch $1{
      		  	      case "TRUE":
      		  	         expr.SetTag(ast.AST_VALUE_NULL)
      		  	      case "FALSE":
      		  	         expr.SetTag(ast.AST_VALUE_NULL)
      		  	    }
			
      		  	    $$ = expr
      		  	}

identifier:
        	IDENT
        	  	{
        	  	  	$$ = $1
        	  	}

identifier_or_star:
          	identifier
          	    {
          	        $$ = $1
          	    }
          	|'*'
              	{
              	    $$ = "*"
              	}
      
variable:
    		single_at_ident
      			{
      			    expr :=&ast.ColumnExpr{Column:$1}
      			    expr.SetTag(ast.AST_EXPR_SINGLE_AT_COLUMN)
  			  		$$ = expr
      			}
    		|double_at_ident
      			{
        			expr :=&ast.ColumnExpr{Column:$1}
        			expr.SetTag(ast.AST_EXPR_DOUBLE_AT_COLUMN)
  			  		$$ = expr
      			}
      		|double_at_ident '.' identifier
      			{
      				expr :=&ast.ColumnExpr{Column:$1}
      				expr.SetTag(ast.AST_EXPR_DOUBLE_AT_COLUMN)
  			  		$$ = expr
      			}




column_ref:
      		identifier_or_star
      			{
       	 			expr :=&ast.ColumnExpr{Column:$1}
       	 			expr.SetTag(ast.AST_EXPR_COLUMN)
  				 	$$ = expr
      			}
      		|identifier '.' identifier_or_star
      			{
					expr :=&ast.ColumnExpr{Relation:&ast.RelationExpr{Table:$1},Column:$2}
					expr.SetTag(ast.AST_EXPR_COLUMN)
  				 	$$ = expr
      			}
      		|identifier '.' identifier '.' identifier_or_star
      			{
      				expr := &ast.ColumnExpr{Relation:&ast.RelationExpr{DB:$1,Table:$2},Column:$3}
      				expr.SetTag(ast.AST_EXPR_COLUMN)
  			 		$$ = expr
      			}


func_expr:
      		func_name '(' ')'
      		 	{
      		 	  expr := &ast.FuncExpr{Name:$1}
      		 	  expr.SetTag(ast.AST_EXPR_FUNC)
      		 	      $$ = expr
      		 	}
			|func_name '(' expr_list ')'
				{
					expr := &ast.FuncExpr{Name:$1,Arg:$3}
					expr.SetTag(ast.AST_EXPR_FUNC)
  			  		$$ = expr
				}
			|agg_expr
				{
					$$ = $1
				}
      		time_expr
      		 	{
      		 	  $$ = $1
      		 	}
      		CAST '(' expr AS cast_type ')'
      		 	{
      		 	  expr := &ast.FuncExpr{Name:"CAST",Arg:ast.List{$3}}
      		 	  expr.SetTag(ast.AST_EXPR_CAST)
      		 	  expr.SetCollate($5)
      		 	      $$ = expr
      		 	}
      		CONVERT '(' expr ',' cast_type ')'
      		 	{
      		 	    expr := &ast.FuncExpr{Name:"CONVERT",Arg:ast.List{$3}}
      		 	    expr.SetTag(ast.AST_EXPR_CONVERT_TYPE)
      		 	    expr.SetCollate($5)
      		 	      $$ = expr
      		 	}
      		CONVERT '(' expr USING alias_name ')'
      		 	{
      		 	    expr := &ast.FuncExpr{Name:"CONVERT",Arg:ast.List{$3}}
      		 	    expr.SetTag(ast.AST_EXPR_CONVERT_ALIAS)
      		 	    expr.SetAlias($5)
      		 	      $$ = expr
      		 	}

agg_expr:
			AVG '(' all_or_distinct expr ')'
				{
					expr := &ast.FuncExpr{Name:"AVG",Arg:ast.List{$4}}
					switch $3{
						case "":
							expr.SetTag(ast.AST_EXPR_AVG)
						case "DISTINCT":
							expr.SetTag(ast.AST_EXPR_AVG_DISTINCT)
						case "DISTINCTROW":
							expr.SetTag(ast.AST_EXPR_AVG_DISTINCTROW)
						case "ALL":
							expr.SetTag(ast.AST_EXPR_AVG_ALL)
					}
  			  		$$ = expr
				}
			|COUNT '(' opt_distinct expr_list ')'
				{
					expr := &ast.FuncExpr{Name:"COUNT",Arg:$4}
					switch $3{
						case "DISTINCT":
							expr.SetTag(ast.AST_EXPR_COUNT_DISTINCT)
						case "DISTINCTROW":
							expr.SetTag(ast.AST_EXPR_COUNT_DISTINCTROW)
					}
					$$ = expr
				}
			|COUNT '(' ALL expr ')'
				{
					expr := &ast.FuncExpr{Name:"COUNT",Arg:ast.List{$4}}
					expr.SetTag(ast.AST_EXPR_COUNT_ALL)
					$$ = expr
				}
			|COUNT '(' expr ')'	
				{
					expr := &ast.FuncExpr{Name:"COUNT",Arg:ast.List{$3}}
					expr.SetTag(ast.AST_EXPR_COUNT)
					$$ = expr
				}
			|COUNT '(' '*' ')'	
				{
					expr := &ast.FuncExpr{Name:"COUNT"}
					expr.SetTag(ast.AST_EXPR_COUNT_STAR)
					$$ = expr
				}
			|MAX '(' all_or_distinct expr ')'
				{
					expr := &ast.FuncExpr{Name:"MAX",Arg:ast.List{$4}}
					switch $3{
						case "":
							expr.SetTag(ast.AST_EXPR_MAX)
						case "DISTINCT":
							expr.SetTag(ast.AST_EXPR_MAX_DISTINCT)
						case "DISTINCTROW":
							expr.SetTag(ast.AST_EXPR_MAX_DISTINCTROW)
						case "ALL":
							expr.SetTag(ast.AST_EXPR_MAX_ALL)
					}
  			  		$$ = expr
				}
			|MIN '(' all_or_distinct expr ')'
				{
					expr := &ast.FuncExpr{Name:"MIN",Arg:ast.List{$4}}
					switch $3{
						case "":
							expr.SetTag(ast.AST_EXPR_MIN)
						case "DISTINCT":
							expr.SetTag(ast.AST_EXPR_MIN_DISTINCT)
						case "DISTINCTROW":
							expr.SetTag(ast.AST_EXPR_MIN_DISTINCTROW)
						case "ALL":
							expr.SetTag(ast.AST_EXPR_MIN_ALL)
					}
  			  		$$ = expr
				}
			|SUM '(' all_or_distinct expr ')'
				{
					expr := &ast.FuncExpr{Name:"SUM",Arg:ast.List{$4}}
					switch $3{
						case "":
							expr.SetTag(ast.AST_EXPR_MAX)
						case "DISTINCT":
							expr.SetTag(ast.AST_EXPR_MAX_DISTINCT)
						case "DISTINCTROW":
							expr.SetTag(ast.AST_EXPR_MAX_DISTINCTROW)
						case "ALL":
							expr.SetTag(ast.AST_EXPR_MAX_ALL)
					}
  			  		$$ = expr
				}

time_expr:
        	func_name_time_add '(' expr ',' INTERVAL expr time_unit ')'
        	  	{
		
        	  	    expr:= &ast.Expr{Operator:"+",Left:$3,Right:$6}
        	  	    expr.SetTag(ast.AST_TIME_INTERVAL)
        	  	    expr.SetAlias($7)
        	  	    $$ = &ast.FuncExpr{Name:$1,Arg:ast.List{expr}}
        	  	}
        	|func_name_time_sub '(' expr ',' INTERVAL expr time_unit ')'
        	  	{
		
        	  	    expr:= &ast.Expr{Operator:"-",Left:$3,Right:$6}
        	  	    expr.SetTag(ast.AST_TIME_INTERVAL)
        	  	    expr.SetAlias($7)
        	  	    $$ = &ast.FuncExpr{Name:$1,Arg:ast.List{expr}}
        	  	}


expr_list:
			expr
				{
					$$ = ast.List{$1}
				}
			|expr_list ',' expr
				{
					$$ = append ($1,$3)
				}


	
marker:
			PARAM_MARKER
				{
					expr :=&ast.ValExpr{Sval:$1}
  				  	expr.SetTag(ast.AST_VALUE_MARKER)
					$$ = expr
				}



case_expr:	
			CASE case_arg when_list else_arg END
				{
					expr := &ast.CaseExpr{Case:$2,When:$3,Else:$4}
					expr.SetTag(ast.AST_EXPR_CASE)
  			  		$$ = expr
				}


case_arg:	expr									
				{ 
					$$ = $1
				}
			| /*EMPTY*/								
				{ 
					$$ = nil 
				}


when_list:
			when_arg							
				{ 
					$$ = ast.List{$1}
				}
			| when_list when_arg		
				{ 
					$$ = append($1, $2) 
				}
		

when_arg:
			WHEN expr THEN expr
				{
					expr := &ast.Expr{Left:$2,Right:$4}
					expr.SetTag(ast.AST_EXPR_WHEN)
  			  		$$ = expr
				}
		

else_arg:
			ELSE expr								
				{ 
					expr := &ast.Expr{Left:$2}
					expr.SetTag(ast.AST_EXPR_ELSE)
  			  		$$ = expr
				}
			| /*EMPTY*/								
				{ 
					$$ = nil 
				}
		
	

opt_target_list:
			target_list								
				{ 
					$$ = $1 
				}
			| /* EMPTY */							
				{ 
					$$ = nil
				}

target_list:
			target_el        						
				{ 
					$$=ast.List{$1}

				}
			|target_list ',' target_el 				
				{ 
					$$ = append($1,$3)
				}


target_el:
            expr opt_alias 			
            	{ 
            		$1.SetAlias($2)
                $$ = $1
            	}

single_at_ident:
            '@' identifier
              	{
              	    $$ = $2
              	}
double_at_ident:
            '@' '@' identifier
            	{
            	    $$ = $3
            	}

func_name:
      		identifier
      		  	{
      		  	  $$ = $1
      		  	}
      		|keyword_as_func
        		{
        		  $$ = $1
        		}

opt_alias:
			alias 						{ $$ = $1 }
			|/*EMPTY*/ 					{ $$ = "" } 

alias:
			AS alias_name 				{ $$ = $2 } 
			|alias_name 				{ $$ = $1 }

alias_name:
			identifier 					{ $$ = $1 }
			|STRING 					{ $$ = $1 }
			|DOUBLE_QUOTA_STRING		{ $$ = $1 }
			|SINGLE_QUOTA_STRING 		{ $$ = $1 }


true_or_false:
			TRUE 						{ $$ = "TRUE" }
			|FALSE 						{ $$ = "FALSE"}



subquery_type:
			SOME 						{ $$ = "SOME" }	
			|ANY 						{ $$ = "ANY" }	
			|ALL 						{ $$ = "ALL" }	

comparison_operator:
 			'='  						{$$ = "="}
 			| GE 						{$$ = ">="}
 			| '>'						{$$ =">"}
 			| LE 						{$$ = "<="}
 			| '<'						{$$ = "<"}
 			| LG						{$$ = "<>"}
 			| LNE						{$$ = "!="}
				
is_or_not:
			IS 							{ $$ = "IS" }
			|IS NOT 					{ $$ = "IS NOT" }
				

opt_not:
			NOT 						{ $$ = "NOT" }
			|/*EMPTY*/ 					{ $$ = "" }

time_unit:
			BuiltinTimeUnitIdent 		{ $$ = $1 }
						

collation_name:
      		BuiltinCharacterIdent   	{ $$ = $1 }
			

keyword_as_func:
     		LEFT                    	{ $$ = "LEFT" }
     		|IN                     	{ $$ = "IN" }
     		|IS                     	{ $$ = "IS" }

cast_type:
      		identifier               	{ $$ = $1 }
	
func_name_time_add:	
      		BuiltinFucTimeAddIdent   	{ $$ = $1 }   
	
func_name_time_sub:                  	     
     		BuiltinFucTimeSubIdent   	{ $$ = $1}        


/*****************************************************************************
 *
 *	distinct clause for SELECT
 *
 *****************************************************************************/

distinct_clause:
			opt_distinct
				{
					clause:=&ast.DistinctClause{}
					switch $1{
						case "DISTINCT":
							clause.SetTag(ast.AST_CLAUSE_DISTINCT)
						case "DISTINCTROW":
							clause.SetTag(ast.AST_CLAUSE_DISTINCTROW)
					}	
					$$ = clause
				}




all_or_distinct:
			ALL										
				{ 
					$$ = $1
				}
			|opt_distinct
				{
					$$ = $1
				}
			| /*EMPTY*/								
				{ 
					$$ = "" 
				}
opt_distinct:
			DISTINCT
				{
					$$ = "DISTINCT"
				}
			| DISTINCTROW
				{
					$$ = "DISTINCTROW"
				}

/*****************************************************************************
 *
 *	into clause for SELECT
 *
 *****************************************************************************/

 into_clause:
 			INTO table_name 							
 				{ 
 					$$ = &ast.IntoClause{Table:$2}
 				}
 			|/*EMPTY*/								
 				{ 
 					$$ = nil
 				}

table_name:
		  	identifier
				{
					$$ = $1
				}
			|STRING
				{
					$$ = $1
				}
			|DOUBLE_QUOTA_STRING
				{
					$$ = $1
				}
				
		  		


/*****************************************************************************
 *
 *	from_clause for SELECT
 *
 *****************************************************************************/

from_clause:
			FROM from_list							
				{ 
					$$ = &ast.FromClause{Table_ref:$2}
				}
			| /*EMPTY*/								
				{ 
					$$ = nil 
				}
		
from_list:
			table_ref								
				{ 
					$$ = ast.List{$1}
				}
			| from_list ',' table_ref				
				{ 
					$$ = append($1,$3) 
				}

table_ref:
			table_factor
				{
					$$ = $1
				}
			|joined_table
				{
					$$ = $1
				}

table_factor:
			relation opt_alias       
				{
          			$1.SetAlias($2)
					$$ = $1
				}
			|select_with_parens alias        
				{
				  	expr:= &ast.SubqueryExpr{Left:nil,Right:$1.(*ast.SelectStmt)}
  					expr.SetTag(ast.AST_SUBQUERY)
  					expr.SetAlias($2)
  					$$ = expr
				}
			|'(' table_refs ')'
				{
					$$ = &ast.RelationListExpr{Relation:$2}
				}

relation:
			table_name    
				{
					tb:=&ast.RelationExpr{Table:$1}
					tb.SetTag(ast.AST_RELATION)
					$$ = tb
				}
			|db_name '.' table_name
				{
					tb:=&ast.RelationExpr{DB:$1,Table:$2}
					tb.SetTag(ast.AST_RELATION)
					$$ = tb
				}

db_name:
			identifier
				{
					$$ = $1
				}
			|STRING
				{
					$$ = $1
				}


table_refs:
			table_ref
				{
					$$ = ast.List{$1}
				}
			|table_refs ',' table_ref
				{
					$$ = append($1,$3)
				}



joined_table:
			//为了保证出现join_qual则一定使用第二条规则进行规约，需要给予第一条规则最低优先级，消除规约冲突
			table_ref inner table_ref %prec LOW
				{
					join := &ast.JoinExpr{Left:$1,Right:$3}
					switch $2{
						case "JOIN":
							join.SetTag(ast.AST_JOIN)
						case "INNER JOIN":
							join.SetTag(ast.AST_INNER_JOIN)
							join.Jtype="INNER"
						case "CROSS JOIN":
							join.SetTag(ast.AST_INNER_JOIN)
							join.Jtype="CROSS"
					}
					$$ = join
				}
			|table_ref inner table_ref join_qual
				{
					join := &ast.JoinExpr{Left:$1,Right:$3,Jqual:$4}
					switch $2{
						case "JOIN":
							join.SetTag(ast.AST_JOIN)
						case "INNER JOIN":
							join.SetTag(ast.AST_INNER_JOIN)
							join.Jtype="INNER"
						case "CROSS JOIN":
							join.SetTag(ast.AST_INNER_JOIN)
							join.Jtype="CROSS"
					}
					$$ = join
				}
			|table_ref STRAIGHT_JOIN table_factor
				{

					join := &ast.JoinExpr{Jtype:"STRAIGHT_JOIN",Left:$1,Right:$3}
					join.SetTag(ast.AST_STRAIGHT_JOIN)
					$$ = join
				}
			|table_ref STRAIGHT_JOIN table_factor ON expr
				{
					join := &ast.JoinExpr{Jtype:"STRAIGHT_JOIN",Left:$1,Right:$3,Jqual:$5}
					join.SetTag(ast.AST_STRAIGHT_JOIN)
					$$ = join
				}
			|table_ref join_type outer_opt JOIN table_ref join_qual
				{
					join := &ast.JoinExpr{Jtype:$2,Outer:$3,Left:$1,Right:$5,Jqual:$6}
					switch $2{
						case "LEFT":
							join.SetTag(ast.AST_LEFT_JOIN)
						case "RIGHT":
							join.SetTag(ast.AST_RIGHT_JOIN)
					}

					$$ = join
				}
			|table_ref NATURAL join_type outer_opt JOIN table_factor
				{
					join := &ast.JoinExpr{Jtype:$3,Outer:$4,Left:$1,Right:$6}
					switch $3{
						case "LEFT":
							join.SetTag(ast.AST_NATURAL_LEFT_JOIN)
						case "RIGHT":
							join.SetTag(ast.AST_NATURAL_RIGHT_JOIN)
					}
					$$ = join
				}

inner:
			JOIN
				{
					$$ = "JOIN"
				}
			|INNER JOIN
				{
					$$ = "INNER JOIN"
				}
			|CROSS JOIN
				{
					$$ = "CROSS JOIN"
				}


join_type:
			LEFT 
				{
					$$ = "LEFT"
				}
			|RIGHT
				{
					$$ = "RIGHT"
				}


outer_opt:
			OUTER 
				{
					$$ ="OUTER"
				}
			|/*EMPTY*/
				{
					$$ = ""
				}

join_qual:
			ON expr 
				{ 
					$$ = $2
				}	
			|USING '(' expr_list ')'					
				{ 
					$$ = &ast.UsingExpr{Column:$3}
				}
				


/*****************************************************************************
 *
 *	where_clause for SELECT
 *
 *****************************************************************************/

where_clause:
			WHERE expr							
				{ 
					$$ = &ast.WhereClause{Where:$2}
				}
			| /*EMPTY*/								
				{ 
					$$ = nil
				}

/*****************************************************************************
 *
 *	group_clause for SELECT
 *
 *****************************************************************************/

group_clause:
			GROUP BY group_by_list					
				{ 
					$$ = &ast.GroupClause{Target_ref:$3}
				}
			| /*EMPTY*/								
				{ 
					$$ = nil
				}


group_by_list:
			group_by_item							
				{ 
					$$ = ast.List{$1}
				}
			| 	group_by_list ',' group_by_item		
				{ 
					$$ = append($1,$3)
				}
		

group_by_item:
			expr									
				{ 
					$$ = $1 
				}


/*****************************************************************************
 *
 *	having_clause for SELECT
 *
 *****************************************************************************/


having_clause:
			HAVING expr							
				{ 
					$$ = &ast.HavingClause{Having:$2}
				}
			| 	/*EMPTY*/								
				{ 
					$$ = nil 
				}



/*****************************************************************************
 *
 *	sort_clause for SELECT
 *
 *****************************************************************************/


opt_sort_clause:
			sort_clause 							
				{	
					$$ = $1
				}
			| 	/*EMPTY*/								
				{ 
					$$ = nil
				}

sort_clause:
			ORDER BY sortby_list					
				{ 
					$$ = &ast.SortClause{Target_ref:$3}
				}


sortby_list:
			sortby									
				{ 
					$$ = ast.List{$1}
				}
			| 	sortby_list ',' sortby				
				{ 
					$$ = append($1,$3)
				}

sortby:
			expr asc_or_desc						
				{ 
					switch node:=$1.(type){
						case *ast.Expr:
							node.SetAsc($2)
					}

					$$ = $1
				}
	
asc_or_desc:
			ASC							
				{ 
					$$ = "ASC" 
				}
			| 	DESC							
				{
					$$ = "DESC" 
				}
			| 	/*EMPTY*/						
				{ 
					$$ = "" 
				}
		
/*****************************************************************************
 *
 *	lock_clause for SELECT
 *
 *****************************************************************************/

opt_for_locking_clause:
			for_locking_clause						{ $$ = $1 }
			| /* EMPTY */							{ $$ = nil }

for_locking_clause:
			FOR UPDATE									
				{ 	
					$$ = &ast.LockClause{Lock:"FOR UPDATE"}
				}
			|LOCK IN SHARE MODE	%prec UMINUS
				{ 	
					$$ = &ast.LockClause{Lock:"LOCK IN SHARE MODE"}
				}


/*****************************************************************************
 *
 *	Limit for SELECT
 *
 *****************************************************************************/

 opt_select_limit:
			select_limit						
				{ 
					$$ = $1
				}
			| /* EMPTY */						
				{ 
					$$ = nil
				}


select_limit:
			limit_list offset_expr			
				{ 
					$$ = &ast.LimitClause{Limit:$1,Offset:$2}
				}
			| offset_expr limit_list		
				{ 
					$$ = &ast.LimitClause{Limit:$2,Offset:$1}
				}
			| limit_list						
				{
					$$ = &ast.LimitClause{Limit:$1}
				}
			| offset_expr					
				{
					$$ = &ast.LimitClause{Offset:$1}
				}


limit_list:
			LIMIT rows
				{ 
					$$ = $2
				}
			| LIMIT rows ',' rows_offset
				{
					$$ = append($2,$4)
				}

rows:
			expr									
				{
					 $$ = ast.List{$1}
				}


rows_offset:
			expr									
				{ 
					$$ = $1 
				}


offset_expr:
			OFFSET rows_offset
				{ 
					$$ = $2 
				}
