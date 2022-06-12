def to_original [] { str replace .pacnew '' }

# Looks for *.pacnew files that need merging.
# If found, start a merge in meld for each file.
export def pacnew [] {
    let pacnew_to_merge = ( fd '.*\.pacnew$' /etc | sk -0 -1 | str trim )
    if ( $pacnew_to_merge | empty? ) {
        echo "No pacnew file to merge"
    } else {
        let original = ( $pacnew_to_merge | to_original )
        let pacnew_tmp = "/tmp/" + ( $pacnew_to_merge | path basename )
        let original_tmp = "/tmp/" + ( $original | path basename )
        cp $pacnew_to_merge $pacnew_tmp
        cp $original $original_tmp
        meld --label $original $original_tmp --label $pacnew_to_merge $pacnew_tmp 
        let success = ( input "Merged? [yN] " )
        if ( $success | str downcase | str contains 'y' ) {
            echo $"Merged ($original) with ($pacnew_to_merge)"
            doas mv $original_tmp $original
            doas rm $pacnew_to_merge
        } else {
            echo $"Merge of ($original) aborted."
            rm $original_tmp
        }
        rm $pacnew_tmp
    }
}