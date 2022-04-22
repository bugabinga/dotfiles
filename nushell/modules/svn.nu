def get-item-status-count [
    svn_status: table # svn status table from xml
    item_status_filter: string # the path item status to count
] {
    let target_status_count = ( $svn_status | get status.children.target.children.entry.children.wc-status.attributes | compact | flatten | flatten | where item == $item_status_filter | length )
    # there will always be a "target" node, but "changelist" is optional
    let changelist_status_count = ( $svn_status | get --ignore-errors status.children.changelist.children.entry.children.wc-status.attributes | compact | flatten | flatten | where item == $item_status_filter | length )
    $target_status_count + $changelist_status_count
}

# Aggregates the output of `svn status` and `svn info` into a table.
# This command operates in the current directory.
# Analog to gstat for svn.
export def-env svnstat [
    ...path: string # optional paths to get svn status from. If empty, the current directory is assumed.
] {
    # the svn info and status commands can handle multiple input paths.
    # TODO empty values, when not in svn directory
    let svn_status = (^svn status --xml $path | from xml)
    let svn_info = (^svn info --xml $path | from xml)
    {
        "path": ( $svn_info | get info.children.entry.attributes.path | path expand )
        "working_copy_root_path": ( $svn_info | get info.children.entry.children.wc-info.children.wcroot-abspath.children | flatten | flatten | flatten | compact )
        "url": ( $svn_info | get info.children.entry.children.url.children | flatten | flatten | compact )
        "relative_url": ( $svn_info | get info.children.entry.children.relative-url.children | flatten | flatten | compact )
        "repository_root": ( $svn_info | get info.children.entry.children.repository.children.root.children | flatten | flatten | flatten | compact )
        "repository_uuid": ( $svn_info | get info.children.entry.children.repository.children.uuid.children | flatten | flatten | flatten | compact )
        "revision": ( $svn_info | get info.children.entry.attributes.revision )
        "node_kind": ( $svn_info | get info.children.entry.attributes.kind )
        "schedule": ( $svn_info | get info.children.entry.children.wc-info.children.schedule.children | flatten | flatten | flatten | compact )
        "last_changed_author": ( $svn_info | get info.children.entry.children.commit.children.author.children | flatten | flatten | flatten | compact )
        "last_changed_rev": ( $svn_info | get info.children.entry.children.commit.attributes.revision | flatten | compact )
        "last_changed_date": ( $svn_info | get info.children.entry.children.commit.children.date.children | flatten | flatten | flatten | compact| into datetime )
        "added": ( get-item-status-count $svn_status "added" )
        "conflicted": "TODO"
        "deleted": ( get-item-status-count $svn_status "deleted" )
        "ignored": ( get-item-status-count $svn_status "ignored" )
        "modified": ( get-item-status-count $svn_status "modified" )
        "replaced": "TODO"
        "unversioned_external": "TODO"
        "unversioned": ( get-item-status-count $svn_status "unversioned" )
        "missing": ( get-item-status-count $svn_status "missing" )
        "obstructed": "TODO"
        "tree_conflicts": ( $svn_status | get --ignore-errors status.children.target.children.entry.children.wc-status.attributes.tree-conflicted | flatten | flatten | compact | length)
        "changelists": ( $svn_status | get --ignore-errors status.children.changelist | compact | flatten | get name )
    }
}
