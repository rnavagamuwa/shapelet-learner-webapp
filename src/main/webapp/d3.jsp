<title>Linking to SlickGrid</title>

<!-- SlickGrid -->
<link rel="stylesheet" href="resources/js/slickgrid/slick.grid.css" type="text/css"/>
<link rel="stylesheet" href="resources/js/slickgrid/jquery-ui-1.8.16.custom.css" type="text/css"/>
<link rel="stylesheet" href="resources/js/slickgrid/examples.css" type="text/css"/>
<link rel="stylesheet" href="resources/js/slickgrid/slick.pager.css" type="text/css"/>
<script src="resources/js/slickgrid/jquery-1.7.min.js"></script>
<script src="resources/js/slickgrid/jquery.event.drag-2.0.min.js"></script>
<script src="resources/js/slickgrid/slick.core.js"></script>
<script src="resources/js/slickgrid/slick.grid.js"></script>
<script src="resources/js/slickgrid/slick.pager.js"></script>
<script src="resources/js/slickgrid/slick.dataview.js"></script>
<!-- End SlickGrid -->

<link rel="stylesheet" type="text/css" href="resources/css/d3/d3.parcoords.css">
<link rel="stylesheet" type="text/css" href="resources/css/d3/style.css">
<style>
    body, html {
        margin: 0;
        height: 100%;
        width: 100%;
        overflow: hidden;
        font-size: 12px;
    }
    #grid, #pager {
        position: fixed;
        width: 100%;
    }
    #grid {
        bottom: 0;
        height: 300px;
    }
    #pager {
        bottom: 306px;
        height: 20px;
    }
    .slick-row:hover {
        font-weight: bold;
        color: #069;
    }
</style>
<script src="resources/js/d3/d3.min.js"></script>
<script src="resources/js/d3/d3.parcoords.js"></script>
<script src="resources/js/d3/divgrid.js"></script>
<input type="file" id="uploader">
<div id="example" class="parcoords" style="height:240px;"></div>
<div id="grid"></div>
<div id="pager"></div>
<script>
    var parcoords = d3.parcoords()("#example")
        .alpha(0.4)
        .mode("queue") // progressive rendering
        .height(d3.max([document.body.clientHeight-326, 220]))
        .margin({
            top: 36,
            left: 0,
            right: 0,
            bottom: 16
        });

    // create chart from loaded data
    function parallelCoordinates(data) {
        // slickgrid needs each data element to have an id
        data.forEach(function(d,i) { d.id = d.id || i; });

        parcoords
            .data(data)
            .render()
            .reorderable()
            .brushMode("1D-axes");

        // setting up grid
        var column_keys = d3.keys(data[0]);
        var columns = column_keys.map(function(key,i) {
            return {
                id: key,
                name: key,
                field: key,
                sortable: true
            }
        });

        var options = {
            enableCellNavigation: true,
            enableColumnReorder: false,
            multiColumnSort: false
        };

        var dataView = new Slick.Data.DataView();
        var grid = new Slick.Grid("#grid", dataView, columns, options);
        var pager = new Slick.Controls.Pager(dataView, grid, $("#pager"));

        // wire up model events to drive the grid
        dataView.onRowCountChanged.subscribe(function (e, args) {
            grid.updateRowCount();
            grid.render();
        });

        dataView.onRowsChanged.subscribe(function (e, args) {
            grid.invalidateRows(args.rows);
            grid.render();
        });

        // column sorting
        var sortcol = column_keys[0];
        var sortdir = 1;

        function comparer(a, b) {
            var x = a[sortcol], y = b[sortcol];
            return (x == y ? 0 : (x > y ? 1 : -1));
        }

        // click header to sort grid column
        grid.onSort.subscribe(function (e, args) {
            sortdir = args.sortAsc ? 1 : -1;
            sortcol = args.sortCol.field;

            if ($.browser.msie && $.browser.version <= 8) {
                dataView.fastSort(sortcol, args.sortAsc);
            } else {
                dataView.sort(comparer, args.sortAsc);
            }
        });

        // highlight row in chart
        grid.onMouseEnter.subscribe(function(e,args) {
            var i = grid.getCellFromEvent(e).row;
            var d = parcoords.brushed() || data;
            parcoords.highlight([d[i]]);
        });
        grid.onMouseLeave.subscribe(function(e,args) {
            parcoords.unhighlight();
        });

        // fill grid with data
        gridUpdate(data);

        // update grid on brush
        parcoords.on("brush", function(d) {
            gridUpdate(d);
        });

        function gridUpdate(data) {
            dataView.beginUpdate();
            dataView.setItems(data);
            dataView.endUpdate();
        };

    };

    // CSV Uploader
    var uploader = document.getElementById("uploader");
    var reader = new FileReader();

    reader.onload = function(e) {
        var contents = e.target.result;
        var data = d3.csv.parse(contents);
        parallelCoordinates(data);

        // remove button, since re-initializing doesn't work for now
        uploader.parentNode.removeChild(uploader);
    };

    uploader.addEventListener("change", handleFiles, false);

    function handleFiles() {
        var file = this.files[0];
        reader.readAsText(file);
    };
</script>
