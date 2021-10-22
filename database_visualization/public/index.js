const upper_strand = 1;

(function (d3) {
    'use strict';

    const svg = d3.select("#graph");

    let width = 0;
    let height = 0;

    d3.json("dummy_data.json").then(data => {
        update(data)
    });

    function update(data) {
        let g = svg.append("g");
        let force = d3.forceSimulation(data.nodes)                 // Force algorithm is applied to data.nodes
            .force("link", d3.forceLink(data.links).id(d => d.id).distance(d => {
                return 70
            }))

        const simulation = force
            .force("charge", d3.forceManyBody().strength(-250))         // This adds repulsion between nodes. Play with the -400 for the repulsion strength
            .force("center", d3.forceCenter(width / 2, height / 2))     // This force attracts nodes to the center of the svg area

        const link = g.append("g")
            .selectAll("line")
            .data(data.links)
            .enter()
            .append("line")
            .style("stroke", "#aaa")

        function zoom_actions({transform}, d) {
            g.attr("transform", transform)
        }

        let zoom_handler = d3.zoom()
            .on("zoom", zoom_actions);

        zoom_handler(svg);
        // Initialize the nodes
        const node = g.selectAll(".node").data(data.nodes).enter().append("g").call(drag(simulation))

        node.append("g").append("circle")
            .attr("r", 15)
            .style("fill", "#69b3a2")
            .on("click", clicked);

        node.append("title")
            .text(d => d.name);

        node.append("text")
            .attr("dx", "-.35em")
            .attr("dy", ".35em")
            .text(function (d) {
                return d.name
            });

        resize();
        d3.select(window).on("resize", resize);

        simulation.on("tick", () => {
            link
                .attr("x1", d => d.source.x)
                .attr("y1", d => d.source.y)
                .attr("x2", d => d.target.x)
                .attr("y2", d => d.target.y);

            node.attr("transform", function (d) {
                return "translate(" + d.x + "," + d.y + ")";
            });

        });

        document.getElementById("filter-seq").onclick = function (event) {
            let ancestor = document.getElementById('fields'),
                descendents = ancestor.getElementsByClassName('input-group');
            // gets all descendent of ancestor
            let i, e, id, pos, exp;
            for (i = 0; i < descendents.length; ++i) {
                e = descendents[i];
                id = e.getElementsByTagName('input')[0].value;
                pos = e.getElementsByTagName('input')[1].value;
                exp = e.getElementsByTagName('select')[0].value;
                console.log(`Id: ${id}; Pos: ${pos}; Expression: ${exp}`);
            }
            let xhr = new XMLHttpRequest();
            xhr.open('GET', '/filter', true);

            xhr.onload = function () {
                $("svg").empty();
                d3.json('dummy_filtered.json').then(data => {
                    update(data)
                });
                // Request finished. Do processing here.
            };
            xhr.send("");
        }

        function clicked(event, d) {
            if (event.defaultPrevented) return;
            fetch("dummy_circuit.json")
                .then(Response => Response.json())
                .then(obj => {
                    let paras = document.getElementsByClassName("cover-item");
                    while (paras[0]) {
                        paras[0].parentNode.removeChild(paras[0]);
                    }
                    paras = document.getElementsByClassName("info-group");
                    while (paras[0]) {
                        paras[0].parentNode.removeChild(paras[0]);
                    }
                    let template = header => {
                        return `<h5 class="info-group" style="font-weight: bold; text-align: left">${header}</h5>`
                    };
                    let info_msg = msg => {
                        return `<h5 class="info-group" id="info" style="overflow-wrap: break-word; white-space: pre-line; text-align: left">${msg}</h5>`
                    };
                    let info_msg2 = msg => {
                        return `<p class="info-group" id="info" style="overflow-wrap: break-word; white-space: pre-line; text-align: left; text-indent: 40px">${msg}</p>`
                    };
                    $(template("Id:")).insertBefore('.info-stop');
                    $(info_msg(`${obj._id.$oid}`)).insertBefore('.info-stop');
                    $(template("Parts:")).insertBefore('.info-stop');
                    let msgg = "";
                    let image;
                    for (let i in obj.sequences) {
                        if (obj.sequences[i].orientation === upper_strand) {
                            image = `<div class="cover-item"><img src="assets/parts/${obj.sequences[i].id}.png" alt="step ${obj.sequences[i].id}"></div>`
                        } else {
                            image = `<div class="cover-item"><img style="-webkit-transform: rotate(180deg);" src="assets/parts/${obj.sequences[i].id}.png" alt="step ${obj.sequences[i].id}"></div>`
                        }
                        $(image).insertBefore('.image-stop');
                        msgg = `${get_name(obj.sequences[i].id)}`
                        $(info_msg(msgg)).insertBefore('.info-stop');
                        msgg = `Orientation: ${get_orientation(obj.sequences[i].orientation)}`
                        $(info_msg2(msgg)).insertBefore('.info-stop');
                        msgg = `Expressing: ${obj.sequences[i].expresable}`
                        $(info_msg2(msgg)).insertBefore('.info-stop');
                    }
                    // or whatever you wanna do with the data
                });

        }

        function resize() {
            const elem = document.getElementById('graph');
            const properties = window.getComputedStyle(elem, null);
            width = parseInt(properties.width, 10);
            height = parseInt(properties.height, 10);
            simulation.force("center", d3.forceCenter(width / 2, height / 2))     // This force attracts nodes to the center of the svg area
        }
    }

    let drag = simulation => {

        function drag_started(event) {
            if (!event.active) simulation.alphaTarget(0.3).restart();
            event.subject.fx = event.subject.x;
            event.subject.fy = event.subject.y;
        }

        function dragged(event) {
            event.subject.fx = event.x;
            event.subject.fy = event.y;
        }

        function drag_ended(event) {
            if (!event.active) simulation.alphaTarget(0);
            event.subject.fx = null;
            event.subject.fy = null;
        }

        return d3.drag()
            .on("start", drag_started)
            .on("drag", dragged)
            .on("end", drag_ended);


    }

}(d3));

let template = '<div class="input-group"><input type="text" class="form-control" id="id" placeholder="Id" style="margin: 7px;">' +
        '                            <input type="text" class="form-control" id="pos" placeholder="Position"' +
        '                                   style="margin: 7px;">' +
        '                            <select class="form-select" aria-label=".form-select-sm example" style="width: 10%; margin: 7px">' +
        '                                <option value="1">Expressing</option>' +
        '                                <option value="2">Not expressing</option>' +
        '                                <option value="3">Both</option>' +
        '                            </select></div>',
    minusButton = '<button class="btn btn-dark input-group-addon delete-field" style="margin: 7px; width: 10%">-</button>';

$('.add-field').click(function () {
    let temp = $(template).insertBefore('.help-block');
    temp.append(minusButton);
});

$('.fields').on('click', '.delete-field', function () {
    $(this).parent().remove();
});

function get_orientation(orientation) {
    if (orientation === upper_strand) {
        return "Upper strand"
    }
    return "Lower strand";
}

function get_name(id) {
    let res;
    switch (id) {
        case 2:
            res = "Recombinase"
            break;
        case 3:
            res = "Site"
            break;
        case 4:
            res = "Terminator"
            break;
        case 5:
            res = "Inducer"
            break;
        case 6:
            res = "SG Recognition"
            break;
        case 7:
            res = "Single Guide"
            break;
        default:
            res = "Promoter"
    }
    return res;
}

function rename() {
    let old_name = document.getElementById('oldId').value
    let new_name = document.getElementById('newId').value
    alert(`Changed id: ${old_name} to: ${new_name}`);
}