#include <ruby.h>
#include "vendor/kdtree.c"

VALUE cKDTreeNode;

struct kdtree * get_tree_from_klass(VALUE klass)
{
  struct kdtree * pointer;
  Data_Get_Struct(klass, struct kdtree, pointer);
  return pointer;
}

static VALUE kd_tree_alloc(VALUE klass)
{
  struct kdtree *tree;

  if (!(tree = malloc(sizeof *tree))) {
    return 0; 
  }

  tree->root  = 0;
  tree->destr = 0;
  tree->rect  = 0;

  VALUE object = Data_Make_Struct(klass, struct kdtree, 0, kd_free, tree);

  return object;
}

static VALUE kd_tree_insert(VALUE klass, VALUE position)
{
  struct kdtree *tree = get_tree_from_klass(klass);
  position = rb_check_array_type(position);

  if (NIL_P(position) || RARRAY_LEN(position) != tree->dim) {
    rb_raise(rb_eRuntimeError, "nodes contain invalid array dimensions");
  }

  int i;
  double pos[tree->dim];

  for (i = 0; i < tree->dim; i++) {
    pos[i] = NUM2DBL(rb_ary_entry(position, i));
  }
  
  kd_insert(tree, pos, 0);

  return position;
}

static VALUE kd_tree_init(VALUE klass, VALUE nodes, VALUE dims)
{
  Check_Type(nodes, T_ARRAY);
  Check_Type(dims, T_FIXNUM);

  struct kdtree *tree = get_tree_from_klass(klass);

  tree->dim = NUM2INT(dims);

  int i;
  for (i = 0; i < RARRAY_LEN(nodes); i++) {
    kd_tree_insert(klass, rb_ary_entry(nodes, i));
  }

  return klass;
}

static VALUE kd_tree_nearest(VALUE klass, VALUE position)
{
  Check_Type(position, T_ARRAY);

  struct kdtree *tree = get_tree_from_klass(klass);
  struct kdhyperrect *rect;
  struct kdnode *result_node = tree->root;
  double pos[tree->dim];
  double dist_sq;
  int i;

  if (!tree) return 0;
  if (!tree->rect) return 0;
  if (!(rect = hyperrect_duplicate(tree->rect))) return 0;

  for (i = 0; i < tree->dim; i++) {
    pos[i] = NUM2DBL(rb_ary_entry(position, i));
    dist_sq += SQ(result_node->pos[i] - pos[i]);
  }

  kd_nearest_i(tree->root, pos, &result_node, &dist_sq, rect);
  hyperrect_free(rect);

  VALUE result = rb_hash_new();

  if (result_node) {
    VALUE result_node_pos = rb_ary_new();

    for (i = 0; i < tree->dim; i++) {
      rb_ary_push(result_node_pos, DBL2NUM(result_node->pos[i]));
    }

    rb_hash_aset(result, rb_str_new2("query"), position);
    rb_hash_aset(result, rb_str_new2("position"), result_node_pos);
    rb_hash_aset(result, rb_str_new2("distance"), DBL2NUM(dist_sq));
  }

  return result;
}

void Init_kd_tree(void) {
  VALUE cKDTree = rb_define_class("KDTree", rb_cObject);
  rb_define_alloc_func(cKDTree, kd_tree_alloc);
  rb_define_method(cKDTree, "initialize", kd_tree_init, 2);
  rb_define_method(cKDTree, "insert", kd_tree_insert, 1);
  rb_define_method(cKDTree, "nearest_neighbor", kd_tree_nearest, 1);
}
