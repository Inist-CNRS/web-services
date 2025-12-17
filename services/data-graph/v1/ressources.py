import networkx as nx
import matplotlib.pyplot as plt
import matplotlib as mpl
import matplotlib.cm as cm
import matplotlib.colors
from itertools import combinations
import numpy as np
import sys
import math

def hex_to_rgb(value):
   value = value.lstrip('#')
   lv = len(value)
   return tuple(int(value[i:i + lv // 3], 16) for i in range(0, lv, lv // 3))


def rgb_to_hex(rgb):
   return '%02x%02x%02x' % rgb

def mean_color(color1, color2):
   rgb1 = hex_to_rgb(color1)
   rgb2 = hex_to_rgb(color2)

   avg = lambda x, y: round((x+y) / 2)

   new_rgb = ()

   for i in range(len(rgb1)):
      new_rgb += (avg(rgb1[i], rgb2[i]),)
       
   return rgb_to_hex(new_rgb)


c1 = "#c9c9c9"
c2 = "#3a3a3a"
def hex_to_RGB(hex_str):
    """ #FFFFFF -> [255,255,255]"""
    #Pass 16 to the integer function for change of base
    return [int(hex_str[i:i+2], 16) for i in range(1,6,2)]


def build_graph(node_weight,edge_weight):
    G = nx.Graph()
    for node in node_weight:
        G.add_node(node,weight=node_weight[node])
    for edge in edge_weight:
        G.add_edge(edge[0],edge[1],weight=edge_weight[edge])
    return G


def build_partition(G):
    partition = nx.community.louvain_communities(G,seed=50,resolution = 1.5)
    p = []
    for i,name in enumerate(G.nodes()):
        for j,part in enumerate(partition):
            if name in part:
                p.append(j)
    return p,partition


def center_gravity(p, partition,r_all):
    pos = p.copy()
    center_all = []
    #calculer le centre de gravité de chaque partition
    for i in range(max(partition)+1):
        center_x = 0
        center_y = 0
        nb = 0
        for j in range(len(pos)):
            if partition[j] == i:
                center_x += pos[j][0]
                center_y += pos[j][1]
                nb += 1
        center_all.append([center_x/nb,center_y/nb])

    #ramener au centre
    nb_0_0 = 0
    for i in range(len(pos)):
        pos[i] = pos[i]-center_all[partition[i]]
        #FIX rajouter du flou pour par avoir de points en 0,0
        if pos[i][0] == 0 and pos[i][1] == 0:
            nb_0_0 += 1
            #Pour degrès e pas d'aleatoire : diviser 360 degrès par le nombre de points ayant (0,0) pour coordonnée. Assigner à chaque angle un points ayant un rayon de 1e-8
            #Puis assigner dans l'ordre chaque ancien points ayant (0,0) par les nouveaux points se trouvant sur le cercle de rayon 1e-8
    if nb_0_0 != 0:
        angle_interval = 2*math.pi/nb_0_0
        count_interval = 0
        for i in range(len(pos)):
            if pos[i][0] == 0 and pos[i][1] == 0:
                pos[i][0] = 1e-4*math.cos(count_interval*angle_interval+1e-4)
                pos[i][1] = 1e-4*math.sin(count_interval*angle_interval+1e-4)
                count_interval += 1 
    #ramener les points trop éloignés de chaque cluster vers le centre du cluster
    #calculer le rayon moyen du cluster
    mean_r_part = [0]*len(center_all)
    for i in range(max(partition)+1):
        nb = 0
        for j in range(len(pos)):
            if partition[j] == i:
                r = np.sqrt((pos[j][0])**2+(pos[j][1])**2)+r_all[j]
                mean_r_part[i] += r
                nb+=1
        mean_r_part[i] = mean_r_part[i]/nb

    #ramener les points trop éloignés du rayon moyen
    for i in range(max(partition)+1):
        for j in range(len(pos)):
            if partition[j] == i:
                r = np.sqrt((pos[j][0])**2+(pos[j][1])**2)+r_all[j]
                if r > 1.5*mean_r_part[i]:
                    pos[j] = pos[j]*mean_r_part[i]/r

    
    #appliquer la gravité pour chaque cluster
    for i in range(max(partition)+1):
        pos_i = []
        r_i = []
        pos_ind = []
        for j in range(len(pos)):
            if partition[j] == i:
                pos_i.append(pos[j])
                pos_ind.append(j)
                r_i.append(r_all[j])
        pos_i = gravity(r_i,pos_i)
        for j in range(len(pos_i)):
            pos[pos_ind[j]] = pos_i[j]  #+np.array(center_all[i])*10
    

    #calculer le nouveau centre après la gravité
    center_all = []
    for i in range(max(partition)+1):
        center_x = 0
        center_y = 0
        nb = 0
        for j in range(len(pos)):
            if partition[j] == i:
                center_x += pos[j][0]#*weights[j]
                center_y += pos[j][1]#*weights[j]
                nb += 1#*weights[j]
        center_all.append([center_x/nb,center_y/nb])

    #trouver le rayon max de chaque partition
    max_r_part = [0]*len(center_all)
    for i in range(max(partition)+1):
        for j in range(len(pos)):
            if partition[j] == i:
                r = np.sqrt((center_all[i][0]-pos[j][0])**2+(center_all[i][1]-pos[j][1])**2)+r_all[j]
                if max_r_part[i] < r:
                    max_r_part[i] = r
    #for i in range(len(max_r_part)):
    #    print("partition = ",i, file=sys.stderr)
    #    print("nb elemnt: ", len([x for x in partition if x == i]),file=sys.stderr)
    #    print("max rayon : ",max_r_part[i],file=sys.stderr)
    #    print("center pos : ", center_all[i], "\n", file=sys.stderr)
    #Appliquer la gravité au nouveau centre
    new_center = gravity(max_r_part,center_all)

    #centrer autour du nouveau centre
    for j in range(len(pos)):
        pos[j] = pos[j]+np.array(new_center[partition[j]])
    return pos

import random

def gravity(r_nodes,nodes_xy):
    save = [k for k in range(len(r_nodes))]
    d = [x*x+y*y for x,y in nodes_xy]
    r_sort,d_sort,xy_sort,save = (list(t) for t in zip(*sorted(zip(r_nodes,d,nodes_xy,save),reverse=True)))
    new_pos = [xy_sort[0]]
    move_factor = 0.0001
    i = 1
    back = False
    while i < len(d_sort):
        x = xy_sort[i][0]
        y = xy_sort[i][1]
        if x == y and x==0: # Prévoit un bug ou l'algo reste coincé dans une boucle infinie quand un point à pour coordonnée (0,0)
            x = 1e-9
            y = 1e-9
        p = x/y
        k = 0

        same_cadrant = []
        for j in range(len(d_sort)):
            if np.sign(xy_sort[j][0]) == np.sign(xy_sort[i][0]) and np.sign(xy_sort[j][1]) == np.sign(xy_sort[i][1]):
                same_cadrant.append(j)
                continue
            d_i_k_2 = (x-xy_sort[j][0])**2 + (y-xy_sort[j][1])**2
            if d_i_k_2 < (r_sort[j] + r_sort[i])**2:
                same_cadrant.append(j)
                continue
            if np.abs(y-xy_sort[j][1]) < r_sort[j] + r_sort[i] or np.abs(x-xy_sort[j][0]) < r_sort[j] + r_sort[i]:
                same_cadrant.append(j)
                continue  
                

        while k < i:
            if k in same_cadrant:
                d_i_k_2 = (x-xy_sort[k][0])**2 + (y-xy_sort[k][1])**2
                while d_i_k_2 < (r_sort[k] + r_sort[i])**2: #intersect
                    if x > 0:
                        x = x+move_factor
                    elif x < 0:
                        x = x-move_factor
                    if x != 0:
                        y = x/p
                    else:
                        y += np.sign(y)*move_factor
                    d_i_k_2 = (x-xy_sort[k][0])**2 + (y-xy_sort[k][1])**2
                for w in same_cadrant:
                    if w < k:
                        d_i_w_2 = (x-xy_sort[w][0])**2 + (y-xy_sort[w][1])**2
                        if d_i_w_2 < (r_sort[w] + r_sort[i])**2:
                            k = 0
                            back = True
                            break
                if back:
                    back = False
                else:
                    k +=1
            else:
                k += 1
        new_pos.append(np.array([x,y]))
        xy_sort[i] = np.array([x,y])
        if y > 1000 :
            exit()

        i+= 1

    _,back_xy = (list(t) for t in zip(*sorted(zip(save,new_pos))))
    return back_xy


def get_weights(autors_list,seuil_edge):
    edge_weight = {}
    for autors in autors_list:
        autors = sorted(autors)
        if len(autors) > 1:
            res = list(combinations(autors,2))
            for edge in res:
                if edge not in edge_weight:
                    edge_weight[edge] = 1
                else:
                    edge_weight[edge] += 1
    ignore_edge = []
    for edge in edge_weight:
        if edge_weight[edge] < seuil_edge:
            ignore_edge.append(edge)

    all_autors = []
    for i in autors_list:
        all_autors += i
    node_weight = {x:1.5*all_autors.count(x) for x in all_autors}
    return node_weight,edge_weight,ignore_edge


def export_to_gexf_full(
    G, node_xyz, r_all, node_color, edge_list, edge_color,
    edge_width, node_name, pid):
    def rgb_to_gexf(color_hex, alpha=1.0):
        """Convert hex color like '#ff8800' into GEXF dict {r,g,b,a}"""
        rgb = matplotlib.colors.to_rgb(color_hex)  # tuple of floats [0-1]
        return {
            "r": int(rgb[0] * 255),
            "g": int(rgb[1] * 255),
            "b": int(rgb[2] * 255),
            "a": float(alpha)
        }
    
    def safe_float(val, default=0.0):
        try:
            if val is None: 
                return float(default)
            return float(val)
        except Exception:
            return float(default)

    # --- Nodes ---
    for i, n in enumerate(node_name):
        for i, n in enumerate(node_name):
            normalized_size = r_all[i]
            G.nodes[n]["viz"] = {
                "position": {
                    "x": safe_float(node_xyz[i][0]),
                    "y": safe_float(node_xyz[i][1]),
                    "z": 0.0,
                },
                "size": safe_float(normalized_size),
                "color": rgb_to_gexf(node_color[i], alpha=1.0),
            }

    # --- Edges ---
    for i, (u, v) in enumerate(edge_list):
        if "viz" not in G.edges[u, v]:
            G.edges[u, v]["viz"] = {}
        G.edges[u, v]["viz"]["color"] = rgb_to_gexf(edge_color[i], alpha=0.3)
        G.edges[u, v]["viz"]["thickness"] = safe_float(edge_width[i]*10)

        G.edges[u, v]["alpha"] = 0.3
        G.edges[u, v]["zorder"] = 1
        G.edges[u, v]["linewidth"] = safe_float(edge_width[i])

    nx.write_gexf(G, "/tmp/"+pid+".gexf")
    return nx.generate_gexf(G)


def plot_2D(G,partition,ignore_edge, pid):
    for i,v in enumerate(G.nodes()):
        G.nodes[v]["subset"] = partition[i]
    pos = nx.spring_layout(G, dim=2, seed=779,center=[0,0])  

    L = {}
    for v in G:
        L[v] = pos[v]
   
    node_xyz = np.array([L[v] for v in G])
    scale = 30000/len(node_xyz)
    node_weights = [scale*np.log(x[1])**2 for x in G.nodes(data="weight")]

    points_whole_ax = 5 * 0.8 * 72
    radius = 0.0001
    r_all = [radius*w for w in node_weights]
    points_radius = 2*radius/1.0*points_whole_ax
    node_weights = [(points_radius*w)**2 for w in node_weights]

    node_xyz = center_gravity(node_xyz,partition,r_all)

    for i,v in enumerate(G):
        L[v] = node_xyz[i]

    edge_xyz = np.array([(L[u], L[v]) for u, v in G.edges()])

    edge_weight = nx.get_edge_attributes(G, "weight")
    edge_weight_list = []
    edge_list = []
    edge_pos = []
    i=0
    for u,v in G.edges():
        if (u,v) not in ignore_edge and (v,u) not in ignore_edge:
            edge_list.append((u,v))
            edge_weight_list.append(edge_weight[u,v])
            edge_pos.append(edge_xyz[i])
        i+=1
    edge_pos = np.array(edge_pos)

    min_xy = np.min(node_xyz,axis=0)
    max_xy = np.max(node_xyz,axis=0)
    m_x = np.maximum(np.abs(min_xy[0]),np.abs(max_xy[0]))
    m_y = np.maximum(np.abs(min_xy[1]),np.abs(max_xy[1]))
    m = np.maximum(m_x,m_y)
    fig = plt.figure()

    resH = 1920
    resW = 1080
    dpi = 800

    fig.set_size_inches(resH/100, resW/100)
    ax = fig.add_subplot()
    ax.set_xlim((-m,m))
    ax.set_ylim((-m,m))
    ax.set_facecolor('black')
    ax.axis("equal")

    node_name = G.nodes()
    node_name = [n for n in node_name]
    node_cmap = cm.get_cmap('gist_rainbow', max(partition) + 1)
    node_color = []
    for i,part in enumerate(partition):
        node_color.append(matplotlib.colors.rgb2hex(node_cmap(part)))

    range_edge = np.linspace(min(edge_weight_list),max(edge_weight_list),100)
    range_width = np.linspace(0.35,1.2,100)
    edge_color = []
    edge_width = []
    for i,w in enumerate(edge_weight_list):
        u,v = edge_list[i]
        u_index = node_name.index(u)
        v_index = node_name.index(v)
        u_color = node_color[u_index]
        v_color = node_color[v_index]
        edge_color.append("#"+mean_color(u_color,v_color))
        closest_value_width = range_width[np.where(range_edge == (min(range_edge, key=lambda x: abs(w- x))))[0][0]]
        edge_width.append(closest_value_width)

    for i,vizedge in enumerate(edge_pos):
        ax.plot(*vizedge.T, color=edge_color[i],linewidth= edge_width[i],zorder=1,alpha=0.3)

    COLOR = 'white'
    mpl.rcParams['text.color'] = COLOR
    for i in range(len(node_weights)):
        circle = plt.Circle(node_xyz[i], r_all[i],zorder=2,linewidth=0.2)
        circle.set_color(matplotlib.colors.rgb2hex(node_cmap(partition[i])))
        circle.set_edgecolor("#000000")
        ax.add_patch(circle)
    for i,name in enumerate(node_name):
        if node_weights[i] > 0.0001*max(node_weights):
            ax.text(*(node_xyz)[i],name,fontsize = 50*r_all[i]*len(node_xyz)/856,horizontalalignment='center',verticalalignment='center')

    def _format_axes(ax):
        """Visualization options for the 3D axes."""
        # Turn gridlines off
        ax.grid(False)
        # Suppress tick labels
        for dim in (ax.xaxis, ax.yaxis, ax.zaxis):
            dim.set_ticks([])
        # Set axes labels
        ax.set_xlabel("x")
        ax.set_ylabel("y")
        ax.set_zlabel("z")


    #_format_axes(ax)
    fig.tight_layout()
    plt.savefig("/tmp/"+pid+'.png', dpi=dpi)
    #plt.show()

    return export_to_gexf_full(G, node_xyz, r_all, node_color,
                               edge_list, edge_color, edge_width, node_name, pid)
