<?php
function smarty_block_mtcustomconfig ( $args, $content, &$ctx, &$repeat ) {
    require( 'block.mtcustomconfigloop.php' );
    $args[ 'lastn' ] = 1;
    return smarty_block_mtcustomconfigloop( $args, $content, $ctx, $repeat );
}
?>