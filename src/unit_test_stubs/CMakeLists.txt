add_subdirectory(csm_share)
add_subdirectory(dyn_subgrid)
add_subdirectory(main)
add_subdirectory(share_esmf)
add_subdirectory(utils)

sourcelist_to_parent(clm_sources)
sourcelist_to_parent(clm_genf90_sources)
sourcelist_to_parent(share_sources)
