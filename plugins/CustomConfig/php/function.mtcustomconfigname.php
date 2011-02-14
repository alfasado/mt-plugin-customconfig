<?php
function smarty_function_mtcustomconfigname ( $args, $ctx ) {
    $customconfig = $ctx->stash( 'config' );
    if (! isset( $customconfig ) ) {
        return $ctx->error();
    } else {
        return $customconfig->name;
    }
}
?>