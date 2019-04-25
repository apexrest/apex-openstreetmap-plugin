function render_osm_map (
    p_region              in apex_plugin.t_region,
    p_plugin              in apex_plugin.t_plugin,
    p_is_printer_friendly in boolean )
    return apex_plugin.t_region_render_result
is
    -- attributes
    height varchar2(10) := nvl(p_region.attribute_01, '700px');
    source varchar(4000) := nvl(p_region.attribute_02, '');
    
    -- variables
    map_data apex_plugin_util.t_column_value_list;
begin
    apex_javascript.add_library (
        p_name      => 'map',
        p_directory => p_plugin.file_prefix || 'assets/js/',
        p_version   => NULL
    );

    map_data := APEX_PLUGIN_UTIL.GET_DATA (
        p_sql_statement    => source,
        p_min_columns      => 1,
        p_max_columns      => 1,
        p_component_name   => p_region.name,
        p_search_type      => NULL,
        p_search_column_no => NULL,
        p_search_string    => NULL,
        p_first_row        => NULL,
        p_max_rows         => 1
    );
    htp.p('
        <div id="mapid" style="width: 100%; height: ' || height || ';"></div>
        <script>       
            function renderMap() {
                var mymap = L.map("mapid").setView([48.5, 31], 6);
                L.tileLayer("http://{s}.tile.osm.org/{z}/{x}/{y}.png", {maxZoom: 18}).addTo(mymap);
          
                updateMap(mymap, ' || map_data(1)(1) || ', "' || p_plugin.file_prefix || '");
            };
        </script>
    ');

    apex_javascript.add_onload_code('renderMap()');
    return null;
end;
