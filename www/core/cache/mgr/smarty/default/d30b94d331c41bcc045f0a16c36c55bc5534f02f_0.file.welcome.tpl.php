<?php /* Smarty version 3.1.27, created on 2017-10-21 12:07:51
         compiled from "/app/www/manager/templates/default/welcome.tpl" */ ?>
<?php
/*%%SmartyHeaderCode:14985371659eb0e67240492_78113041%%*/
if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'd30b94d331c41bcc045f0a16c36c55bc5534f02f' => 
    array (
      0 => '/app/www/manager/templates/default/welcome.tpl',
      1 => 1505291566,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '14985371659eb0e67240492_78113041',
  'variables' => 
  array (
    'dashboard' => 0,
  ),
  'has_nocache_code' => false,
  'version' => '3.1.27',
  'unifunc' => 'content_59eb0e672a1c04_64693544',
),false);
/*/%%SmartyHeaderCode%%*/
if ($_valid && !is_callable('content_59eb0e672a1c04_64693544')) {
function content_59eb0e672a1c04_64693544 ($_smarty_tpl) {

$_smarty_tpl->properties['nocache_hash'] = '14985371659eb0e67240492_78113041';
?>
<div id="modx-panel-welcome-div"></div>

<div id="modx-dashboard" class="dashboard">
<?php echo $_smarty_tpl->tpl_vars['dashboard']->value;?>

</div><?php }
}
?>